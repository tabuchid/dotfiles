"use strict";var K=Object.create;var g=Object.defineProperty;var J=Object.getOwnPropertyDescriptor;var H=Object.getOwnPropertyNames;var Z=Object.getPrototypeOf,q=Object.prototype.hasOwnProperty;var E=(e,t)=>{for(var r in t)g(e,r,{get:t[r],enumerable:!0})},v=(e,t,r,n)=>{if(t&&typeof t=="object"||typeof t=="function")for(let a of H(t))!q.call(e,a)&&a!==r&&g(e,a,{get:()=>t[a],enumerable:!(n=J(t,a))||n.enumerable});return e};var Y=(e,t,r)=>(r=e!=null?K(Z(e)):{},v(t||!e||!e.__esModule?g(r,"default",{value:e,enumerable:!0}):r,e)),X=e=>v(g({},"__esModule",{value:!0}),e);var pe={};E(pe,{default:()=>B});module.exports=X(pe);var u=require("@raycast/api");var M=require("child_process"),W=require("util"),f=require("@raycast/api");var h=Y(require("react")),l=require("@raycast/api");var A=require("react/jsx-runtime");var S={};E(S,{exclude:()=>ie,extract:()=>k,parse:()=>x,parseUrl:()=>D,pick:()=>F,stringify:()=>j,stringifyUrl:()=>N});var T="%[a-f0-9]{2}",P=new RegExp("("+T+")|([^%]+?)","gi"),R=new RegExp("("+T+")+","gi");function y(e,t){try{return[decodeURIComponent(e.join(""))]}catch{}if(e.length===1)return e;t=t||1;let r=e.slice(0,t),n=e.slice(t);return Array.prototype.concat.call([],y(r),y(n))}function Q(e){try{return decodeURIComponent(e)}catch{let t=e.match(P)||[];for(let r=1;r<t.length;r++)e=y(t,r).join(""),t=e.match(P)||[];return e}}function ee(e){let t={"%FE%FF":"\uFFFD\uFFFD","%FF%FE":"\uFFFD\uFFFD"},r=R.exec(e);for(;r;){try{t[r[0]]=decodeURIComponent(r[0])}catch{let a=Q(r[0]);a!==r[0]&&(t[r[0]]=a)}r=R.exec(e)}t["%C2"]="\uFFFD";let n=Object.keys(t);for(let a of n)e=e.replace(new RegExp(a,"g"),t[a]);return e}function $(e){if(typeof e!="string")throw new TypeError("Expected `encodedURI` to be of type `string`, got `"+typeof e+"`");try{return decodeURIComponent(e)}catch{return ee(e)}}function C(e,t){let r={};if(Array.isArray(t))for(let n of t){let a=Object.getOwnPropertyDescriptor(e,n);a?.enumerable&&Object.defineProperty(r,n,a)}else for(let n of Reflect.ownKeys(e)){let a=Object.getOwnPropertyDescriptor(e,n);if(a.enumerable){let s=e[n];t(n,s,e)&&Object.defineProperty(r,n,a)}}return r}function b(e,t){if(!(typeof e=="string"&&typeof t=="string"))throw new TypeError("Expected the arguments to be of type `string`");if(e===""||t==="")return[];let r=e.indexOf(t);return r===-1?[]:[e.slice(0,r),e.slice(r+t.length)]}var te=e=>e==null,re=e=>encodeURIComponent(e).replaceAll(/[!'()*]/g,t=>`%${t.charCodeAt(0).toString(16).toUpperCase()}`),w=Symbol("encodeFragmentIdentifier");function ne(e){switch(e.arrayFormat){case"index":return t=>(r,n)=>{let a=r.length;return n===void 0||e.skipNull&&n===null||e.skipEmptyString&&n===""?r:n===null?[...r,[c(t,e),"[",a,"]"].join("")]:[...r,[c(t,e),"[",c(a,e),"]=",c(n,e)].join("")]};case"bracket":return t=>(r,n)=>n===void 0||e.skipNull&&n===null||e.skipEmptyString&&n===""?r:n===null?[...r,[c(t,e),"[]"].join("")]:[...r,[c(t,e),"[]=",c(n,e)].join("")];case"colon-list-separator":return t=>(r,n)=>n===void 0||e.skipNull&&n===null||e.skipEmptyString&&n===""?r:n===null?[...r,[c(t,e),":list="].join("")]:[...r,[c(t,e),":list=",c(n,e)].join("")];case"comma":case"separator":case"bracket-separator":{let t=e.arrayFormat==="bracket-separator"?"[]=":"=";return r=>(n,a)=>a===void 0||e.skipNull&&a===null||e.skipEmptyString&&a===""?n:(a=a===null?"":a,n.length===0?[[c(r,e),t,c(a,e)].join("")]:[[n,c(a,e)].join(e.arrayFormatSeparator)])}default:return t=>(r,n)=>n===void 0||e.skipNull&&n===null||e.skipEmptyString&&n===""?r:n===null?[...r,c(t,e)]:[...r,[c(t,e),"=",c(n,e)].join("")]}}function ae(e){let t;switch(e.arrayFormat){case"index":return(r,n,a)=>{if(t=/\[(\d*)]$/.exec(r),r=r.replace(/\[\d*]$/,""),!t){a[r]=n;return}a[r]===void 0&&(a[r]={}),a[r][t[1]]=n};case"bracket":return(r,n,a)=>{if(t=/(\[])$/.exec(r),r=r.replace(/\[]$/,""),!t){a[r]=n;return}if(a[r]===void 0){a[r]=[n];return}a[r]=[...a[r],n]};case"colon-list-separator":return(r,n,a)=>{if(t=/(:list)$/.exec(r),r=r.replace(/:list$/,""),!t){a[r]=n;return}if(a[r]===void 0){a[r]=[n];return}a[r]=[...a[r],n]};case"comma":case"separator":return(r,n,a)=>{let i=typeof n=="string"&&n.includes(e.arrayFormatSeparator)?n.split(e.arrayFormatSeparator).map(o=>p(o,e)):n===null?n:p(n,e);a[r]=i};case"bracket-separator":return(r,n,a)=>{let s=/(\[])$/.test(r);if(r=r.replace(/\[]$/,""),!s){a[r]=n&&p(n,e);return}let i=n===null?[]:p(n,e).split(e.arrayFormatSeparator);if(a[r]===void 0){a[r]=i;return}a[r]=[...a[r],...i]};default:return(r,n,a)=>{if(a[r]===void 0){a[r]=n;return}a[r]=[...[a[r]].flat(),n]}}}function U(e){if(typeof e!="string"||e.length!==1)throw new TypeError("arrayFormatSeparator must be single character string")}function c(e,t){return t.encode?t.strict?re(e):encodeURIComponent(e):e}function p(e,t){return t.decode?$(e):e}function O(e){return Array.isArray(e)?e.sort():typeof e=="object"?O(Object.keys(e)).sort((t,r)=>Number(t)-Number(r)).map(t=>e[t]):e}function _(e){let t=e.indexOf("#");return t!==-1&&(e=e.slice(0,t)),e}function se(e){let t="",r=e.indexOf("#");return r!==-1&&(t=e.slice(r)),t}function I(e,t,r){return r==="string"&&typeof e=="string"?e:typeof r=="function"&&typeof e=="string"?r(e):r==="boolean"&&e===null?!0:r==="boolean"&&e!==null&&(e.toLowerCase()==="true"||e.toLowerCase()==="false")?e.toLowerCase()==="true":r==="boolean"&&e!==null&&(e.toLowerCase()==="1"||e.toLowerCase()==="0")?e.toLowerCase()==="1":r==="string[]"&&t.arrayFormat!=="none"&&typeof e=="string"?[e]:r==="number[]"&&t.arrayFormat!=="none"&&!Number.isNaN(Number(e))&&typeof e=="string"&&e.trim()!==""?[Number(e)]:r==="number"&&!Number.isNaN(Number(e))&&typeof e=="string"&&e.trim()!==""?Number(e):t.parseBooleans&&e!==null&&(e.toLowerCase()==="true"||e.toLowerCase()==="false")?e.toLowerCase()==="true":t.parseNumbers&&!Number.isNaN(Number(e))&&typeof e=="string"&&e.trim()!==""?Number(e):e}function k(e){e=_(e);let t=e.indexOf("?");return t===-1?"":e.slice(t+1)}function x(e,t){t={decode:!0,sort:!0,arrayFormat:"none",arrayFormatSeparator:",",parseNumbers:!1,parseBooleans:!1,types:Object.create(null),...t},U(t.arrayFormatSeparator);let r=ae(t),n=Object.create(null);if(typeof e!="string"||(e=e.trim().replace(/^[?#&]/,""),!e))return n;for(let a of e.split("&")){if(a==="")continue;let s=t.decode?a.replaceAll("+"," "):a,[i,o]=b(s,"=");i===void 0&&(i=s),o=o===void 0?null:["comma","separator","bracket-separator"].includes(t.arrayFormat)?o:p(o,t),r(p(i,t),o,n)}for(let[a,s]of Object.entries(n))if(typeof s=="object"&&s!==null&&t.types[a]!=="string")for(let[i,o]of Object.entries(s)){let d=t.types[a],m=typeof d=="function"?d:d?d.replace("[]",""):void 0;s[i]=I(o,t,m)}else typeof s=="object"&&s!==null&&t.types[a]==="string"?n[a]=Object.values(s).join(t.arrayFormatSeparator):n[a]=I(s,t,t.types[a]);return t.sort===!1?n:(t.sort===!0?Object.keys(n).sort():Object.keys(n).sort(t.sort)).reduce((a,s)=>{let i=n[s];return a[s]=i&&typeof i=="object"&&!Array.isArray(i)?O(i):i,a},Object.create(null))}function j(e,t){if(!e)return"";t={encode:!0,strict:!0,arrayFormat:"none",arrayFormatSeparator:",",...t},U(t.arrayFormatSeparator);let r=i=>t.skipNull&&te(e[i])||t.skipEmptyString&&e[i]==="",n=ne(t),a={};for(let[i,o]of Object.entries(e))r(i)||(a[i]=o);let s=Object.keys(a);return t.sort!==!1&&s.sort(t.sort),s.map(i=>{let o=e[i];if(t.replacer&&(o=t.replacer(i,o),o===void 0)||o===void 0)return"";if(o===null)return c(i,t);if(Array.isArray(o)){if(o.length===0&&t.arrayFormat==="bracket-separator")return c(i,t)+"[]";let d=o;return t.replacer&&(d=o.map((m,G)=>t.replacer(`${i}[${G}]`,m)).filter(m=>m!==void 0)),d.reduce(n(i),[]).join("&")}return c(i,t)+"="+c(o,t)}).filter(i=>i.length>0).join("&")}function D(e,t){t={decode:!0,...t};let[r,n]=b(e,"#");return r===void 0&&(r=e),{url:r?.split("?")?.[0]??"",query:x(k(e),t),...t&&t.parseFragmentIdentifier&&n?{fragmentIdentifier:p(n,t)}:{}}}function N(e,t){t={encode:!0,strict:!0,[w]:!0,...t};let r=_(e.url).split("?")[0]||"",n=k(e.url),a={...x(n,{sort:!1,...t}),...e.query},s=j(a,t);s&&=`?${s}`;let i=se(e.url);if(typeof e.fragmentIdentifier=="string"){let o=new URL(r);o.hash=e.fragmentIdentifier,i=t[w]?o.hash:`#${e.fragmentIdentifier}`}return`${r}${s}${i}`}function F(e,t,r){r={parseFragmentIdentifier:!0,[w]:!1,...r};let{url:n,query:a,fragmentIdentifier:s}=D(e,r);return N({url:n,query:C(a,t),fragmentIdentifier:s},r)}function ie(e,t,r){let n=Array.isArray(t)?a=>!t.includes(a):(a,s)=>!t(a,s);return F(e,n,r)}var L=S;var Ce=(0,f.getPreferenceValues)();var oe="tag => tag.name()",ce=`todo => {
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
}`,le=`project => {
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
    todos: project.toDos().map(${ce})
  };
}`,ue=`todo => {
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
}`,fe=`area => {
  const props = area.properties();
  return {
    id: props.id,
    name: props.name,
    tags: area.tagNames(),
    todos: area.toDos().map(${ue})
  };
}`,Ie=[{name:"tags",needs:["tags"],expr:`things.tags().map(${oe})`},{name:"projects",needs:["projects","lists"],expr:`things.projects().map(${le})`},{name:"areas",needs:["areas","lists"],expr:`things.areas().map(${fe})`}];async function de(e){await(0,W.promisify)(M.exec)(`open -g "${e}"`)}function he(e){return L.stringify(e,{skipNull:!0,skipEmptyString:!0})}async function z(e){await de(`things:///add?${he(e)}`)}function V(e,t){if(e instanceof Error&&e.message==="unauthorized"){(0,f.showToast)({style:f.Toast.Style.Failure,title:"This action needs an authentication token.",message:`Please set it in the extension preferences.
You can find your unique token in Things\u2019 settings. go to Things \u2192 Settings \u2192 General \u2192 Enable Things URLs \u2192 Manage`,primaryAction:{title:"Open Extension Preferences",onAction(r){(0,f.openExtensionPreferences)(),r.hide()}}});return}(0,f.showToast)({style:f.Toast.Style.Failure,title:t??"Something went wrong",message:e instanceof Error?e.message:String(e)})}async function B(e){try{let{shouldCloseMainWindow:t,dontUseAI:r}=(0,u.getPreferenceValues)(),n,a;if(t?await(0,u.closeMainWindow)():await(0,u.showToast)({style:u.Toast.Style.Animated,title:"Adding to-do"}),r||!u.environment.canAccess(u.AI)){let{text:s}=e.arguments;n={title:s},a=`Added "${s}" to 'Inbox'`}else{let s=await u.AI.ask(`Act as a task manager. I'll give you a task in a natural language. Your job is to return me only a parsable and minified JSON object.

Here are the possible keys of the JSON object with their respective values:
- title: The title of the to-do.
- when: Possible values: "today", "tomorrow", "evening", "anytime", "someday", natural language dates such as "in 3 days" or "next tuesday", or a date time string (natural language dates followed by the @ symbol and then followed by a time string. E.g. "this friday@14:00".).
- deadline: The deadline to apply to the to-do. Only can be a date string (yyyy-mm-dd).
- tags: Comma separated strings corresponding to the titles of tags.
- list: The title of a project or area to add to.
- heading: The title of a heading within a project to add to.
- completed: Whether or not the to-do should be set to complete.
- canceled: Whether or not the to-do should be set to canceled.

Please make sure to follow these rules:
- You should return a valid, parsable JSON object.
- Don't add a key if the user didn't specify it.

Here are some examples to help you out:
- Book flights today in my Trips list: {"title":"Book flights","when":"today","list":"Trips"}
- Add milk to my groceries list for tomorrow with Errand tag: {"title":"Milk","when":"tomorrow","list":"Groceries","tags":"Errand"}
- Respond to mails: {"title":"Respond to mails"}
- Buy a new car by the end of the year: {"title":"Buy a new car","deadline":"2023-12-31"}
- Collect dry cleaning this evening at 7PM: {"title":"Collect dry cleaning","when":"evening@19:00"}
- Fix landing page this Friday in bugs heading of Revamp Homepage project: {"title":"Fix landing page","when":"this friday","list":"Revamp Homepage","heading":"Bugs"}
- Add a completed task called "Ship feature" to my Work list: {"title":"Ship feature","list":"Work","completed":"true"}
- Answer to mails by this week-end: {"title":"Answer to mails","deadline":"2023-09-08"}

Here's the task: "${e.fallbackText??e.arguments.text}"`);n=JSON.parse(s.trim())}e.arguments.notes&&(n.notes=e.arguments.notes),e.arguments.checklist&&(n["checklist-items"]=e.arguments.checklist.split(",").map(s=>s.trim()).join(`
`)),await z(n),await(0,u.showToast)({style:u.Toast.Style.Success,title:"Added to-do",message:a})}catch(t){V(t,"Unable to add to-do")}}
