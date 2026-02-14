"use strict";var F=Object.create;var a=Object.defineProperty;var O=Object.getOwnPropertyDescriptor;var P=Object.getOwnPropertyNames;var A=Object.getPrototypeOf,h=Object.prototype.hasOwnProperty;var M=(e,t)=>{for(var r in t)a(e,r,{get:t[r],enumerable:!0})},d=(e,t,r,p)=>{if(t&&typeof t=="object"||typeof t=="function")for(let o of P(t))!h.call(e,o)&&o!==r&&a(e,o,{get:()=>t[o],enumerable:!(p=O(t,o))||p.enumerable});return e};var R=(e,t,r)=>(r=e!=null?F(A(e)):{},d(t||!e||!e.__esModule?a(r,"default",{value:e,enumerable:!0}):r,e)),E=e=>d(a({},"__esModule",{value:!0}),e);var V={};M(V,{default:()=>U});module.exports=E(V);var n=require("@raycast/api");var s=require("@raycast/api");var m=R(require("node:process"),1),f=require("node:util"),c=require("node:child_process"),L=(0,f.promisify)(c.execFile);async function i(e,{humanReadableOutput:t=!0,signal:r}={}){if(m.default.platform!=="darwin")throw new Error("macOS only");let p=t?[]:["-ss"],o={};r&&(o.signal=r);let{stdout:v}=await L("osascript",["-e",e,p],o);return v.trim()}function w(e){return`
    tell application "${e}"
      set currentTab to active tab of front window
      set tabURL to URL of currentTab
      return tabURL
    end tell
  `}function g(){return`
    tell application "Arc"
      tell front window
        set activeTabURL to URL of active tab
        return activeTabURL
      end tell
    end tell
  `}function x(e){return`
    tell application "${e}"
      activate
      delay 0.5
      
      tell application "System Events"
        keystroke "l" using {command down}
        delay 0.2
        keystroke "c" using {command down}
        delay 0.5
        key code 53
      end tell
    end tell
      
    delay 0.5
    
    set copiedURL to do shell script "pbpaste"
    
    return copiedURL
  `}var u=["Arc","Brave","Firefox","Firefox Developer Edition","Google Chrome","Microsoft Edge","Mozilla Firefox","Opera","QQ","Safari","Sogou Explorer","Vivaldi","Yandex","Zen"],y=`
    set cmd to "lsappinfo metainfo | grep -E -o '${u.join("|")}' | head -1"

    set frontmostBrowser to do shell script cmd

    return frontmostBrowser
`;var k="https://meet.google.com/new",$=/^[0-9]+$/,D=500;function C(e){return u.includes(e)}function b(){let e=(0,s.getPreferenceValues)();return $.test(e.timeout)?Number.parseInt(e.timeout,10):D}function S(){return(0,s.getPreferenceValues)().preferredBrowser}function B(e){return new Promise(t=>setTimeout(t,e))}async function N(){let e=await Q();return e==="Arc"?await i(g()):e==="Firefox"||e==="Firefox Developer Edition"||e==="Zen"?await i(x(e)):await i(w(e))}async function Q(){let e=S();return e?.name&&C(e.name)?e.name:await i(y)}async function l(){let t=(await N()).split(",").find(r=>r.includes("meet.google.com"));return t?.includes("/new")?await l():t}async function T(){let e=S();await(0,s.open)(k,e?.name)}async function U(){try{await T();let e=b();await B(e);let t=await l();await n.Clipboard.copy(t),await(0,n.showHUD)("Copied meet link to clipboard")}catch{await(0,n.showToast)({style:n.Toast.Style.Failure,title:"Couldn't copy to clipboard"})}}
