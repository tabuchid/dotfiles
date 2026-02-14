"use strict";var w=Object.create;var u=Object.defineProperty;var k=Object.getOwnPropertyDescriptor;var x=Object.getOwnPropertyNames;var v=Object.getPrototypeOf,S=Object.prototype.hasOwnProperty;var E=(e,t)=>{for(var n in t)u(e,n,{get:t[n],enumerable:!0})},p=(e,t,n,s)=>{if(t&&typeof t=="object"||typeof t=="function")for(let i of x(t))!S.call(e,i)&&i!==n&&u(e,i,{get:()=>t[i],enumerable:!(s=k(t,i))||s.enumerable});return e};var d=(e,t,n)=>(n=e!=null?w(v(e)):{},p(t||!e||!e.__esModule?u(n,"default",{value:e,enumerable:!0}):n,e)),A=e=>p(u({},"__esModule",{value:!0}),e);var _={};E(_,{default:()=>R});module.exports=A(_);var l=require("@raycast/api");var o=d(require("react")),r=require("@raycast/api");var c=d(require("node:fs")),f=d(require("node:path"));var b=require("react/jsx-runtime");function g(e,t){let n=e instanceof Error?e.message:String(e);return(0,r.showToast)({style:r.Toast.Style.Failure,title:t?.title??"Something went wrong",message:t?.message??n,primaryAction:t?.primaryAction??m(e),secondaryAction:t?.primaryAction?m(e):void 0})}var m=e=>{let t=!0,n="[Extension Name]...",s="";try{let a=JSON.parse((0,c.readFileSync)((0,f.join)(r.environment.assetsPath,"..","package.json"),"utf8"));n=`[${a.title}]...`,s=`https://raycast.com/${a.owner||a.author}/${a.name}`,(!a.owner||a.access==="public")&&(t=!1)}catch{}let i=r.environment.isDevelopment||t,h=e instanceof Error?e?.stack||e?.message||"":String(e);return{title:i?"Copy Logs":"Report Error",onAction(a){a.hide(),i?r.Clipboard.copy(h):(0,r.open)(`https://github.com/raycast/extensions/issues/new?&labels=extension%2Cbug&template=extension_bug_report.yml&title=${encodeURIComponent(n)}&extension-url=${encodeURI(s)}&description=${encodeURIComponent(`#### Error:
\`\`\`
${h}
\`\`\`
`)}`)}}};var $=require("node:child_process");async function T(e){if(process.platform!=="darwin")throw new Error("macOS only");let t=process.env.LC_ALL;delete process.env.LC_ALL;let{stdout:n,stderr:s}=(0,$.spawnSync)("osascript",["-e",e]);if(process.env.LC_ALL=t,s?.length)throw new Error(s.toString());return n.toString()}async function y(e){let t=`
    if application "${e}" is not running then
      error "${e} is not running"
    end if

    tell application "Finder" to activate
    tell application "${e}" to activate
    tell application "System Events"
      keystroke "open -a Finder ./"
      key code 76
    end tell
  `;try{let n=await T(t);await(0,l.showToast)(l.Toast.Style.Success,"Done",n)}catch(n){await g(n)}}var R=async()=>await y("Ghostty");
