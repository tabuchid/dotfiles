"use strict";var E=Object.create;var f=Object.defineProperty;var A=Object.getOwnPropertyDescriptor;var T=Object.getOwnPropertyNames;var R=Object.getPrototypeOf,_=Object.prototype.hasOwnProperty;var U=(e,t)=>{for(var r in t)f(e,r,{get:t[r],enumerable:!0})},b=(e,t,r,s)=>{if(t&&typeof t=="object"||typeof t=="function")for(let o of T(t))!_.call(e,o)&&o!==r&&f(e,o,{get:()=>t[o],enumerable:!(s=A(t,o))||s.enumerable});return e};var p=(e,t,r)=>(r=e!=null?E(R(e)):{},b(t||!e||!e.__esModule?f(r,"default",{value:e,enumerable:!0}):r,e)),P=e=>b(f({},"__esModule",{value:!0}),e);var I={};U(I,{default:()=>C});module.exports=P(I);var c=p(require("react")),n=require("@raycast/api");var l=p(require("node:fs")),d=p(require("node:path"));var $=require("react/jsx-runtime");function u(e,t){let r=e instanceof Error?e.message:String(e);return(0,n.showToast)({style:n.Toast.Style.Failure,title:t?.title??"Something went wrong",message:t?.message??r,primaryAction:t?.primaryAction??g(e),secondaryAction:t?.primaryAction?g(e):void 0})}var g=e=>{let t=!0,r="[Extension Name]...",s="";try{let i=JSON.parse((0,l.readFileSync)((0,d.join)(n.environment.assetsPath,"..","package.json"),"utf8"));r=`[${i.title}]...`,s=`https://raycast.com/${i.owner||i.author}/${i.name}`,(!i.owner||i.access==="public")&&(t=!1)}catch{}let o=n.environment.isDevelopment||t,m=e instanceof Error?e?.stack||e?.message||"":String(e);return{title:o?"Copy Logs":"Report Error",onAction(i){i.hide(),o?n.Clipboard.copy(m):(0,n.open)(`https://github.com/raycast/extensions/issues/new?&labels=extension%2Cbug&template=extension_bug_report.yml&title=${encodeURIComponent(r)}&extension-url=${encodeURI(s)}&description=${encodeURIComponent(`#### Error:
\`\`\`
${m}
\`\`\`
`)}`)}}};var a=require("@raycast/api");var y=require("node:child_process");async function w(e){if(process.platform!=="darwin")throw new Error("macOS only");let t=process.env.LC_ALL;delete process.env.LC_ALL;let{stdout:r,stderr:s}=(0,y.spawnSync)("osascript",["-e",e]);if(process.env.LC_ALL=t,s?.length)throw new Error(s.toString());return r.toString()}var h=e=>e!=="Clipboard"&&e!=="Finder";async function k(e){if(!(await(0,a.getApplications)()).find(s=>s.name===e))throw new Error(`${e} not found`)}async function x(e){try{let t=await a.Clipboard.readText()||"";await k(e),await(0,a.open)(t,e),await(0,a.showToast)(a.Toast.Style.Success,"Done")}catch(t){await u(t)}}async function v(e){let t=`
    if application "${e}" is not running then
      error "${e} is not running"
    end if

    tell application "Finder" to activate
    tell application "${e}" to activate
    tell application "System Events"
      keystroke "open -a Finder ./"
      key code 76
    end tell
  `;try{let r=await w(t);await(0,a.showToast)(a.Toast.Style.Success,"Done",r)}catch(r){await u(r)}}async function S(e){let t=`
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
  `;try{let r=await w(t);await k(e),await(0,a.open)(r.trim(),e),await(0,a.showToast)(a.Toast.Style.Success,"Done")}catch(r){await u(r)}}async function C(e){let{from:t,to:r}=e.arguments;try{if(t==="Clipboard"&&h(r))await x(r);else if(t==="Finder"&&h(r))await S(r);else if(h(t)&&r==="Finder")await v(t);else throw new Error("Invalid combination")}catch(s){await u(s)}}
