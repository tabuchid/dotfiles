"use strict";var F=Object.create;var b=Object.defineProperty;var B=Object.getOwnPropertyDescriptor;var G=Object.getOwnPropertyNames;var K=Object.getPrototypeOf,J=Object.prototype.hasOwnProperty;var H=(r,t)=>{for(var e in t)b(r,e,{get:t[e],enumerable:!0})},R=(r,t,e,a)=>{if(t&&typeof t=="object"||typeof t=="function")for(let n of G(t))!J.call(r,n)&&n!==e&&b(r,n,{get:()=>t[n],enumerable:!(a=B(t,n))||a.enumerable});return r};var w=(r,t,e)=>(e=r!=null?F(K(r)):{},R(t||!r||!r.__esModule?b(e,"default",{value:r,enumerable:!0}):e,r)),Z=r=>R(b({},"__esModule",{value:!0}),r);var pe={};H(pe,{default:()=>he});module.exports=Z(pe);var m=require("@raycast/api");var f=w(require("react")),o=require("@raycast/api");var I=w(require("node:child_process")),C=require("node:buffer"),p=w(require("node:stream")),O=require("node:util");var j=require("react/jsx-runtime");var k=globalThis;var $=r=>!!r&&typeof r=="object"&&typeof r.removeListener=="function"&&typeof r.emit=="function"&&typeof r.reallyExit=="function"&&typeof r.listeners=="function"&&typeof r.kill=="function"&&typeof r.pid=="number"&&typeof r.on=="function",x=Symbol.for("signal-exit emitter"),S=class{constructor(){if(this.emitted={afterExit:!1,exit:!1},this.listeners={afterExit:[],exit:[]},this.count=0,this.id=Math.random(),k[x])return k[x];Object.defineProperty(k,x,{value:this,writable:!1,enumerable:!1,configurable:!1})}on(t,e){this.listeners[t].push(e)}removeListener(t,e){let a=this.listeners[t],n=a.indexOf(e);n!==-1&&(n===0&&a.length===1?a.length=0:a.splice(n,1))}emit(t,e,a){if(this.emitted[t])return!1;this.emitted[t]=!0;let n=!1;for(let s of this.listeners[t])n=s(e,a)===!0||n;return t==="exit"&&(n=this.emit("afterExit",e,a)||n),n}},E=class{onExit(){return()=>{}}load(){}unload(){}},P=class{#o;#t;#e;#s;#i;#a;#n;#r;constructor(t){this.#o=process.platform==="win32"?"SIGINT":"SIGHUP",this.#t=new S,this.#a={},this.#n=!1,this.#r=[],this.#r.push("SIGHUP","SIGINT","SIGTERM"),globalThis.process.platform!=="win32"&&this.#r.push("SIGALRM","SIGABRT","SIGVTALRM","SIGXCPU","SIGXFSZ","SIGUSR2","SIGTRAP","SIGSYS","SIGQUIT","SIGIOT"),globalThis.process.platform==="linux"&&this.#r.push("SIGIO","SIGPOLL","SIGPWR","SIGSTKFLT"),this.#e=t,this.#a={};for(let e of this.#r)this.#a[e]=()=>{let a=this.#e.listeners(e),{count:n}=this.#t,s=t;if(typeof s.__signal_exit_emitter__=="object"&&typeof s.__signal_exit_emitter__.count=="number"&&(n+=s.__signal_exit_emitter__.count),a.length===n){this.unload();let i=this.#t.emit("exit",null,e),c=e==="SIGHUP"?this.#o:e;i||t.kill(t.pid,c)}};this.#i=t.reallyExit,this.#s=t.emit}onExit(t,e){if(!$(this.#e))return()=>{};this.#n===!1&&this.load();let a=e?.alwaysLast?"afterExit":"exit";return this.#t.on(a,t),()=>{this.#t.removeListener(a,t),this.#t.listeners.exit.length===0&&this.#t.listeners.afterExit.length===0&&this.unload()}}load(){if(!this.#n){this.#n=!0,this.#t.count+=1;for(let t of this.#r)try{let e=this.#a[t];e&&this.#e.on(t,e)}catch{}this.#e.emit=(t,...e)=>this.#l(t,...e),this.#e.reallyExit=t=>this.#c(t)}}unload(){this.#n&&(this.#n=!1,this.#r.forEach(t=>{let e=this.#a[t];if(!e)throw new Error("Listener not defined for signal: "+t);try{this.#e.removeListener(t,e)}catch{}}),this.#e.emit=this.#s,this.#e.reallyExit=this.#i,this.#t.count-=1)}#c(t){return $(this.#e)?(this.#e.exitCode=t||0,this.#t.emit("exit",this.#e.exitCode,null),this.#i.call(this.#e,this.#e.exitCode)):0}#l(t,...e){let a=this.#s;if(t==="exit"&&$(this.#e)){typeof e[0]=="number"&&(this.#e.exitCode=e[0]);let n=a.call(this.#e,t,...e);return this.#t.emit("exit",this.#e.exitCode,null),n}else return a.call(this.#e,t,...e)}},v=null,q=(r,t)=>(v||(v=$(process)?new P(process):new E),v.onExit(r,t));function Y(r,{timeout:t}={}){let e=new Promise((c,l)=>{r.on("exit",(u,h)=>{c({exitCode:u,signal:h,timedOut:!1})}),r.on("error",u=>{l(u)}),r.stdin&&r.stdin.on("error",u=>{l(u)})}),a=q(()=>{r.kill()});if(t===0||t===void 0)return e.finally(()=>a());let n,s=new Promise((c,l)=>{n=setTimeout(()=>{r.kill("SIGTERM"),l(Object.assign(new Error("Timed out"),{timedOut:!0,signal:"SIGTERM"}))},t)}),i=e.finally(()=>{clearTimeout(n)});return Promise.race([s,i]).finally(()=>a())}var A=class extends Error{constructor(){super("The output is too big"),this.name="MaxBufferError"}};function X(r){let{encoding:t}=r,e=t==="buffer",a=new p.default.PassThrough({objectMode:!1});t&&t!=="buffer"&&a.setEncoding(t);let n=0,s=[];return a.on("data",i=>{s.push(i),n+=i.length}),a.getBufferedValue=()=>e?Buffer.concat(s,n):s.join(""),a.getBufferedLength=()=>n,a}async function T(r,t){let e=X(t);return await new Promise((a,n)=>{let s=i=>{i&&e.getBufferedLength()<=C.constants.MAX_LENGTH&&(i.bufferedData=e.getBufferedValue()),n(i)};(async()=>{try{await(0,O.promisify)(p.default.pipeline)(r,e),a()}catch(i){s(i)}})(),e.on("data",()=>{e.getBufferedLength()>8e7&&s(new A)})}),e.getBufferedValue()}async function _(r,t){r.destroy();try{return await t}catch(e){return e.bufferedData}}async function Q({stdout:r,stderr:t},{encoding:e},a){let n=T(r,{encoding:e}),s=T(t,{encoding:e});try{return await Promise.all([a,n,s])}catch(i){return Promise.all([{error:i,exitCode:null,signal:i.signal,timedOut:i.timedOut||!1},_(r,n),_(t,s)])}}function ee(r){let t=typeof r=="string"?`
`:10,e=typeof r=="string"?"\r":13;return r[r.length-1]===t&&(r=r.slice(0,-1)),r[r.length-1]===e&&(r=r.slice(0,-1)),r}function U(r,t){return r.stripFinalNewline?ee(t):t}function te({timedOut:r,timeout:t,signal:e,exitCode:a}){return r?`timed out after ${t} milliseconds`:e!=null?`was killed with ${e}`:a!=null?`failed with exit code ${a}`:"failed"}function re({stdout:r,stderr:t,error:e,signal:a,exitCode:n,command:s,timedOut:i,options:c,parentError:l}){let h=`Command ${te({timedOut:i,timeout:c?.timeout,signal:a,exitCode:n})}: ${s}`,g=e?`${h}
${e.message}`:h,y=[g,t,r].filter(Boolean).join(`
`);return e?e.originalMessage=e.message:e=l,e.message=y,e.shortMessage=g,e.command=s,e.exitCode=n,e.signal=a,e.stdout=r,e.stderr=t,"bufferedData"in e&&delete e.bufferedData,e}function ne({stdout:r,stderr:t,error:e,exitCode:a,signal:n,timedOut:s,command:i,options:c,parentError:l}){if(e||a!==0||n!==null)throw re({error:e,exitCode:a,signal:n,stdout:r,stderr:t,command:i,timedOut:s,options:c,parentError:l});return r}async function D(r,t,e){if(process.platform!=="darwin")throw new Error("AppleScript is only supported on macOS");let{humanReadableOutput:a,language:n,timeout:s,...i}=Array.isArray(t)?e||{}:t||{},c=a!==!1?[]:["-ss"];n==="JavaScript"&&c.push("-l","JavaScript"),Array.isArray(t)&&c.push("-",...t);let l=I.default.spawn("osascript",c,{...i,env:{PATH:"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"}}),u=Y(l,{timeout:s??1e4});l.stdin.end(r);let[{error:h,exitCode:g,signal:y,timedOut:N},M,z]=await Q(l,{encoding:"utf8"},u),W=U({stripFinalNewline:!0},M),V=U({stripFinalNewline:!0},z);return ne({stdout:W,stderr:V,error:h,exitCode:g,signal:y,timedOut:N,command:"osascript",options:e,parentError:new Error})}var ae=(0,m.getPreferenceValues)(),d=class extends Error{constructor(e,a,n,s){super(s?`${s}: ${e}`:e);this.type=a;this.originalError=n;this.operation=s;this.name="ThingsError"}},se=async(r,t)=>{try{let e=await D(`(function(){${r}})()`,{humanReadableOutput:!1,language:"JavaScript",timeout:6e4});return e?JSON.parse(e.replace(/:\s*undefined/g,": null")):void 0}catch(e){let n=(typeof e=="string"?e:e instanceof Error?e.message:String(e)).replace("execution error: Error: ","");throw n.match(/Application can't be found/i)?new d("Things application not found. Please make sure Things is installed and running.","APP_NOT_FOUND",n,t):n.match(/not allowed assistive access/i)||n.match(/permission/i)||n.match(/-1743/)?new d("Permission denied. Please grant Raycast access to Things in System Settings > Privacy & Security > Automation > Raycast > Things.","PERMISSION_DENIED",n,t):n.match(/doesn't understand/i)||n.match(/can't get/i)?new d("Things automation interface error. This might be due to a Things version incompatibility or the app not being ready.","EXECUTION_ERROR",n,t):n.match(/timed out/i)?new d("Command timed out. Things may be unresponsive or not running.","EXECUTION_ERROR",n,t):new d(`Unexpected error: ${n}`,"UNKNOWN_ERROR",n,t)}};var ie="tag => tag.name()",oe=`todo => {
  const props = todo.properties();
  return {
    id: props.id,
    name: props.name,
    status: props.status,
    notes: props.notes,
    tags: todo.tagNames(),
    dueDate: props.dueDate ? props.dueDate.toISOString() : null,
    activationDate: props.activationDate ? props.activationDate.toISOString() : null,
  };
}`,ce=`project => {
  const props = project.properties();
  const areaRef = props.area;
  let area = null;
  if (areaRef) {
    const areaProps = areaRef.properties();
    area = { id: areaProps.id, name: areaProps.name, tags: areaRef.tagNames() };
  }
  return {
    id: props.id,
    name: props.name,
    status: props.status,
    notes: props.notes,
    tags: project.tagNames(),
    dueDate: props.dueDate ? props.dueDate.toISOString() : null,
    activationDate: props.activationDate ? props.activationDate.toISOString() : null,
    area,
    todos: project.toDos().map(${oe})
  };
}`,le=`todo => {
  const props = todo.properties();
  return {
    id: props.id,
    name: props.name,
    status: props.status,
    notes: props.notes,
    tags: todo.tagNames(),
    dueDate: props.dueDate ? props.dueDate.toISOString() : null,
    activationDate: props.activationDate ? props.activationDate.toISOString() : null,
    isProject: props.pcls === "project",
  };
}`,ue=`area => {
  const props = area.properties();
  return {
    id: props.id,
    name: props.name,
    tags: area.tagNames(),
    todos: area.toDos().map(${le})
  };
}`,fe=[{name:"tags",needs:["tags"],expr:`things.tags().map(${ie})`},{name:"projects",needs:["projects","lists"],expr:`things.projects().map(${ce})`},{name:"areas",needs:["areas","lists"],expr:`things.areas().map(${ue})`}];async function L(...r){let t=new Set(r),e=[`const things = Application('${ae.thingsAppIdentifier}');`,"const result = {};",...fe.filter(({needs:n})=>n.some(s=>t.has(s))).map(({name:n,expr:s})=>`result.${n} = ${s};`),"return result;"].join(`
`),a=await se(e,`Get ${r.join(", ")}`);return Object.fromEntries(r.map(n=>[n,n==="lists"?de(a.projects,a.areas):a[n]]))}function de(r=[],t=[]){let e=r.filter(n=>!n.area).map(n=>({...n,type:"project"})),a=[];return t.forEach(n=>{a.push({...n,type:"area"});let s=r.filter(i=>i.area&&i.area.id===n.id).map(i=>({...i,type:"project"}));a.push(...s)}),[...e,...a]}async function he(){let{lists:r}=await L("lists");return r}
