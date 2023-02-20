const fs = require("fs");
const path = require("path");
const puppeteer = require("puppeteer");
const cheerio = require("cheerio");

const file_name = "20221125.csv";
const file_path = path.join(__dirname, file_name);

console.log(file_path);

const csv = fs.readFileSync(file_path, "utf-8");
const rows = csv.split("\r\n");

init(rows);

async function init(rows) {
    let index = 0
    for( const row of rows) {
        // row 형태
        // 가맹점ID,가맹점명,가맹점유형코드,시도명,시군구명,시군구코드,소재지도로명주소,소재지도로명주소상세정보,소재지지번주소,소재지지번주소상세정보,전화번호,사업자번호,종사업자번호,대표자명,사업자상태,사업자상태변경일,프랜차이즈명,일반직영,음식점분류,시설정보구분,위도,경도,평일운영시작시각,평일운영종료시각,토요일운영시작시각,토요일운영종료시각,공휴일운영시작시각,공휴일운영종료시각,배달시작시각,배달종료시각,아침점심저녁구분,배달가능여부,관리기관,관리기관전화번호,데이터기준일자
        const split = row.split(",");
        const storeName = split[1];
        const sotreType = split[2];
        const storeAddress = split[6]
    
        if(sotreType === "20") {
            continue
        }
        const searchName = storeName + " " + storeAddress;
        console.log(storeName);
        if(index > 0){
            await searchPuppeteer(searchName);
        }
        index++
    }
}


// puppeteer & cheerio
const result = {};
async function searchPuppeteer(searchName) {
    const browser = await puppeteer.launch({headless: false, devtools: true,});
    const page = await browser.newPage();
    await page.setViewport({width: 1000, height: 10000});
    await page.goto("https://map.naver.com/v5/search/" + searchName);
    await page.waitForTimeout(1000);
    await page.setDefaultTimeout(5000)
    let frame;
    // 검색결과가 없는경우 빠르게 브라우저를 닫아주기 위한 timer.
    const timer = setTimeout(() => {
        browser.close();
    }, 5000);
    timer;
    // 검색결과가 있는지 없는지 try catch문
    try{
        frame = await page.waitForFrame(async frame => {
            return frame.name() === 'entryIframe';
        });
        clearTimeout(timer);
    }catch{
        console.log(searchName +' 검색 결과가 없습니다.');
        result[searchName] = [];
        return;
    }

    wait(1);

    // 검색 결과가 있어도 menu정보가 없을 경우를 대비한 예외처리 
    const menuBtn = await frame.$eval('.flicking-camera > a:nth-child(2) > span', el => el.innerText);
    if(menuBtn !== '메뉴') {
        console.log("메뉴 버튼이 없습니다.");
        result[searchName] = [];
        browser.close();
        return;
    }
    // menu정보가 있을경우 menu버튼 클릭
    // await frame.click('.flicking-camera > a:nth-child(2)');
    try{
        const element = await frame.waitForSelector('.fvwqf');
        await element.click();
        await frame.waitForNavigation();
    }catch{
        const element = await frame.waitForSelector('.flicking-camera > a:nth-child(2) > span');
        await element.click();
    }
    await checkSeemore(frame);
    result[searchName] = await checkMenu(frame);;
    browser.close();
    const json = JSON.stringify(result[searchName])
    fs.appendFileSync('menu.txt', `${searchName} : ${json}`);
    console.log(result);
}

function wait(sec) {
    let start = Date.now(), now = start;
    while (now - start < sec * 1000) {
        now = Date.now();
    }
}

async function getMenu(nameClass, priceClass, ul) {
    const arr = [];
        const allName = await ul.$$(nameClass);
        const allPrice = await ul.$$(priceClass);
        for(const i in allName) {
            const name = await allName[i].evaluate(n => n.innerText);
            const price = await allPrice[i].evaluate(p => p.innerText);
            arr.push({name, price})
        }
        return arr;
}

async function checkSeemore(page) {
    const content = await page.content();
    if(content.indexOf("list_place_col1") !== -1) {
        try{
            await page.click('.place_tab_detail > div:nth-child(3) > div > a');
            await checkSeemore(page);
            return
        }catch{
            return
        }
    }
    if(content.indexOf("lfH3O") !== -1) {
        try{
            console.log('그냥 메뉴에서 더보기 있을경우');
            await page.click('.lfH3O');
            await checkSeemore(page);
            return;
        }catch{
            return
        } 
    }
    return;
}

async function checkMenu(page) {
    let ul;
    let menu;
    const content = await page.content();
    if(content.indexOf('ZUYk_') !== -1) {
        ul = await page.waitForSelector('.ZUYk_');
        menu = await getMenu('.Sqg65', '.SSaNE', ul);
    }else if(content.indexOf('list_place_col1') !== -1) {
        ul = await page.waitForSelector('.list_place_col1');
        menu = await getMenu('.name', '.price', ul);
    }else {
        console.log('나머지');
        menu = ''
    }
    return menu;
}