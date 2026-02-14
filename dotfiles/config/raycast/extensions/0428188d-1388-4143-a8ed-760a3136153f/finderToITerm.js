"use strict";var k=Object.create;var u=Object.defineProperty;var x=Object.getOwnPropertyDescriptor;var v=Object.getOwnPropertyNames;var S=Object.getPrototypeOf,E=Object.prototype.hasOwnProperty;var A=(e,t)=>{for(var n in t)u(e,n,{get:t[n],enumerable:!0})},b=(e,t,n,s)=>{if(t&&typeof t=="object"||typeof t=="function")for(let i of v(t))!E.call(e,i)&&i!==n&&u(e,i,{get:()=>t[i],enumerable:!(s=x(t,i))||s.enumerable});return e};var h=(e,t,n)=>(n=e!=null?k(S(e)):{},b(t||!e||!e.__esModule?u(n,"default",{value:e,enumerable:!0}):n,e)),T=e=>b(u({},"__esModule",{value:!0}),e);var _={};A(_,{default:()=>R});module.exports=T(_);var d=require("@raycast/api");var l=require("@raycast/api");var o=h(require("react")),r=require("@raycast/api");var c=h(require("node:fs")),f=h(require("node:path"));var $=require("react/jsx-runtime");function p(e,t){let n=e instanceof Error?e.message:String(e);return(0,r.showToast)({style:r.Toast.Style.Failure,title:t?.title??"Something went wrong",message:t?.message??n,primaryAction:t?.primaryAction??g(e),secondaryAction:t?.primaryAction?g(e):void 0})}var g=e=>{let t=!0,n="[Extension Name]...",s="";try{let a=JSON.parse((0,c.readFileSync)((0,f.join)(r.environment.assetsPath,"..","package.json"),"utf8"));n=`[${a.title}]...`,s=`https://raycast.com/${a.owner||a.author}/${a.name}`,(!a.owner||a.access==="public")&&(t=!1)}catch{}let i=r.environment.isDevelopment||t,m=e instanceof Error?e?.stack||e?.message||"":String(e);return{title:i?"Copy Logs":"Report Error",onAction(a){a.hide(),i?r.Clipboard.copy(m):(0,r.open)(`https://github.com/raycast/extensions/issues/new?&labels=extension%2Cbug&template=extension_bug_report.yml&title=${encodeURIComponent(n)}&extension-url=${encodeURI(s)}&description=${encodeURIComponent(`#### Error:
\`\`\`
${m}
\`\`\`
`)}`)}}};var y=require("node:child_process");async function w(e){if(process.platform!=="darwin")throw new Error("macOS only");let t=process.env.LC_ALL;delete process.env.LC_ALL;let{stdout:n,stderr:s}=(0,y.spawnSync)("osascript",["-e",e]);if(process.env.LC_ALL=t,s?.length)throw new Error(s.toString());return n.toString()}var R=async()=>{let e=`
        if application "Finder" is not running then
            return "Not running"
        end if

        tell application "Finder"
            set pathList to (quoted form of POSIX path of (folder of the front window as alias))
        end tell
    `;e+=`
        tell application "System Events"
            -- some versions might identify as "iTerm2" instead of "iTerm"
            set isRunning to (exists (processes where name is "iTerm")) or (exists (processes where name is "iTerm2"))
        end tell

        tell application "iTerm"
            activate
            set hasNoWindows to ((count of windows) is 0)
            if isRunning and hasNoWindows then
                create window with default profile
            end if
            select first window

            tell the first window
            if isRunning and hasNoWindows is false then
                create tab with default profile
            end if
            tell current session to write text "clear; cd " & pathList
            end tell
        end tell
    `;try{let t=await w(e);await(0,d.showToast)(d.Toast.Style.Success,"Done",t)}catch(t){await p(t)}};
