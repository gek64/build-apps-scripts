// 通过是否带有 .后缀名 判断是否是文件
function isFile(pathname) {
    return pathname.split('/').pop().indexOf('.') > -1
}

// 获取所有的链接并存储到数组返回
function getAllLinks() {
    let arr = []
    let links = document.links
    for (let i = 0; i < links.length; i++) {
        arr.push(links[i].href)
    }
    return arr
}

// 数组中符合是文件的链接拼接成字符串
function linksToString(arr) {
    let content = ""
    for (var i = 0; i < arr.length; i++) {
        if (isFile(arr[i])) {
            content = content + arr[i] + "\n"
        }
    }
    return content
}

// 将字符串拼接到文件流中并下载
function downloadFileWithContent(str) {
    let dlbutton = document.createElement('a')
    dlbutton.href = "data:application/octet-stream," + encodeURIComponent(str)
    dlbutton.download = 'all_links.txt'
    dlbutton.click()
}

// 将字符串弹出到textarea中
function popTextarea(str) {
    let newWindow = window.open("", "", "width=1000px,height=800px")
    newWindow.document.write("<textarea style='width: 100%;height: 97vh;'>" + str + "</textarea>")
}

// 启动
function run() {
    arr = getAllLinks()
    str = linksToString(arr)
    popTextarea(str)
}

run()


// Minify
// https://skalman.github.io/UglifyJS-online/
// Bookmarklet
// javascript: (() => {js_content})()
// javascript: (() => {function isFile(t){return t.split("/").pop().indexOf(".")>-1}function getAllLinks(){let t=[],n=document.links;for(let e=0;e<n.length;e++)t.push(n[e].href);return t}function linksToString(t){let n="";for(var e=0;e<t.length;e++)isFile(t[e])&&(n=n+t[e]+"\n");return n}function popTextarea(t){window.open("","","width=1000px,height=800px").document.write("<textarea style='width: 100%;height: 97vh;'>"+t+"</textarea>")}function run(){arr=getAllLinks(),str=linksToString(arr),popTextarea(str)}run();})()


