"use strict";var w=Object.create;var u=Object.defineProperty;var k=Object.getOwnPropertyDescriptor;var x=Object.getOwnPropertyNames;var v=Object.getPrototypeOf,S=Object.prototype.hasOwnProperty;var E=(e,t)=>{for(var n in t)u(e,n,{get:t[n],enumerable:!0})},p=(e,t,n,a)=>{if(t&&typeof t=="object"||typeof t=="function")for(let o of x(t))!S.call(e,o)&&o!==n&&u(e,o,{get:()=>t[o],enumerable:!(a=k(t,o))||a.enumerable});return e};var d=(e,t,n)=>(n=e!=null?w(v(e)):{},p(t||!e||!e.__esModule?u(n,"default",{value:e,enumerable:!0}):n,e)),A=e=>p(u({},"__esModule",{value:!0}),e);var U={};E(U,{default:()=>_});module.exports=A(U);var i=require("@raycast/api");var c=d(require("react")),r=require("@raycast/api");var l=d(require("node:fs")),f=d(require("node:path"));var b=require("react/jsx-runtime");function g(e,t){let n=e instanceof Error?e.message:String(e);return(0,r.showToast)({style:r.Toast.Style.Failure,title:t?.title??"Something went wrong",message:t?.message??n,primaryAction:t?.primaryAction??m(e),secondaryAction:t?.primaryAction?m(e):void 0})}var m=e=>{let t=!0,n="[Extension Name]...",a="";try{let s=JSON.parse((0,l.readFileSync)((0,f.join)(r.environment.assetsPath,"..","package.json"),"utf8"));n=`[${s.title}]...`,a=`https://raycast.com/${s.owner||s.author}/${s.name}`,(!s.owner||s.access==="public")&&(t=!1)}catch{}let o=r.environment.isDevelopment||t,h=e instanceof Error?e?.stack||e?.message||"":String(e);return{title:o?"Copy Logs":"Report Error",onAction(s){s.hide(),o?r.Clipboard.copy(h):(0,r.open)(`https://github.com/raycast/extensions/issues/new?&labels=extension%2Cbug&template=extension_bug_report.yml&title=${encodeURIComponent(n)}&extension-url=${encodeURI(a)}&description=${encodeURIComponent(`#### Error:
\`\`\`
${h}
\`\`\`
`)}`)}}};var $=require("node:child_process");async function T(e){if(process.platform!=="darwin")throw new Error("macOS only");let t=process.env.LC_ALL;delete process.env.LC_ALL;let{stdout:n,stderr:a}=(0,$.spawnSync)("osascript",["-e",e]);if(process.env.LC_ALL=t,a?.length)throw new Error(a.toString());return n.toString()}async function R(e){if(!(await(0,i.getApplications)()).find(a=>a.name===e))throw new Error(`${e} not found`)}async function y(e){let t=`
    if application "Finder" is not running then
        return "Finder is not running"
    end if

    tell application "Finder"
      if (count of Finder windows) = 0 then error "No Finder window open"
      try
        set pathList to POSIX path of (folder of the front window as alias)
        return pathList
      on error
        error "Could not access Finder window path"
      end try
    end tell
  `;try{let n=await T(t);await R(e),await(0,i.open)(n.trim(),e),await(0,i.showToast)(i.Toast.Style.Success,"Done")}catch(n){await g(n)}}var _=async()=>await y("Ghostty");
