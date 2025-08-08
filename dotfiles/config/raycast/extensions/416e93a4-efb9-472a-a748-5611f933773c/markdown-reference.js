"use strict";var c=Object.defineProperty;var g=Object.getOwnPropertyDescriptor;var f=Object.getOwnPropertyNames;var b=Object.prototype.hasOwnProperty;var x=(t,n)=>{for(var i in n)c(t,i,{get:n[i],enumerable:!0})},y=(t,n,i,a)=>{if(n&&typeof n=="object"||typeof n=="function")for(let e of f(n))!b.call(t,e)&&e!==i&&c(t,e,{get:()=>n[e],enumerable:!(a=g(n,e))||a.enumerable});return t};var T=t=>y(c({},"__esModule",{value:!0}),t);var H={};x(H,{default:()=>M});module.exports=T(H);var o=require("@raycast/api"),k=require("react");var v=[{name:"Blockquotes",description:"To create a blockquote, add a `>` in front of a paragraph.",examples:[{markdown:"> Dorothy followed her through many of the beautiful rooms in her castle.",html:"<blockquote><p>Dorothy followed her through many of the beautiful rooms in her castle.</p></blockquote>"}],additional_examples:[{name:"Blockquotes with Multiple Paragraphs",description:"Blockquotes can contain multiple paragraphs. Add a `>` on the blank lines between the paragraphs.",markdown:`> Dorothy followed her through many of the beautiful rooms in her castle.

>

> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.
`,html:"<blockquote><p>Dorothy followed her through many of the beautiful rooms in her castle.</p><p>The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.</p></blockquote>"},{name:"Nested Blockquotes",description:"Blockquotes can be nested. Add a `>>` in front of the paragraph you want to nest.",markdown:`> Dorothy followed her through many of the beautiful rooms in her castle.

>

>> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.
`,html:"<blockquote><p>Dorothy followed her through many of the beautiful rooms in her castle.</p><blockquote><p>The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.</p></blockquote></blockquote>"},{name:"Blockquotes with Other Elements",description:"Blockquotes can contain other Markdown formatted elements. Not all elements can be used \u2014 you'll need to experiment to see which ones work.",markdown:`> ### The quarterly results look great!

>

> - Revenue was off the chart.

> - Profits were higher than ever.

>

>  *Everything* is going according to **plan**.
`,html:"<blockquote><h3>The quarterly results look great!</h3><ul><li>Revenue was off the chart.</li><li>Profits were higher than ever.</li></ul><p><em>Everything</em> is going according to <strong>plan</strong>.</p></blockquote>"}]},{name:"Bold",description:"To bold text, add two asterisks or underscores before and after a word or phrase. To bold the middle of a word for emphasis, add two asterisks without spaces around the letters.",examples:[{markdown:"I just love **bold text**.",html:"I just love <strong>bold text</strong>."},{markdown:"I just love __bold text__.",html:"I just love <strong>bold text</strong>."},{markdown:"Love**is**bold",html:"Love<strong>is</strong>bold"}],additional_examples:[]},{name:"Code",description:"To denote a word or phrase as code, enclose it in tick marks (`` ` ``).",examples:[{markdown:"At the command prompt, type `nano`.",html:"At the command prompt, type <code>nano</code>."}],additional_examples:[{name:"Escaping Tick Marks",description:"If the word or phrase you want to denote as code includes one or more tick marks, you can escape it by enclosing the word or phrase in double tick marks (<code>``</code>).",markdown:"``Use `code` in your Markdown file.``",html:"<code>Use `code` in your Markdown file.</code>"},{name:"Code Blocks",description:"To create code blocks, indent every line of the block by at least four spaces or one tab.",markdown:`&nbsp;<html>

&nbsp;&nbsp;&nbsp;<head>

&nbsp;&nbsp;&nbsp;</head>

&nbsp;</html>
`,html:"<pre><code><html><head></head></html></code></pre>"}]},{name:"Headings",description:"To create a heading, add number signs (`#`) in front of a word or phrase. The number of number signs you use should correspond to the heading level. For example, to create a heading level three (`<h3>`), use three number signs (e.g., `### My Header`).",examples:[{markdown:"# Heading level 1",html:"<h1>Heading level 1</h1>"},{markdown:"## Heading level 2",html:"<h2>Heading level 2</h2>"},{markdown:"### Heading level 3",html:"<h3>Heading level 3</h3>"},{markdown:"#### Heading level 4",html:"<h4>Heading level 4</h4>"},{markdown:"##### Heading level 5",html:"<h5>Heading level 5</h5>"},{markdown:"###### Heading level 6",html:"<h6>Heading level 6</h6>"}],additional_examples:[{name:"Alternative H1 Syntax",description:"Alternatively, on the line below the text, add any number of == characters for heading level 1.",markdown:`Heading level 1

===============
`,html:"<h1>Heading level 1</h1>"},{name:"Alternative H2 Syntax",description:"Alternatively, on the line below the text, add any number of -- characters for heading level 2.",markdown:`Heading level 2

---------------
`,html:"<h2>Heading level 2</h2>"}]},{name:"Horizontal Rules",description:"To create a horizontal rule, use three or more asterisks (`***`), dashes (`---`), or underscores (`___`) on a line by themselves.",examples:[{markdown:"***",html:"<hr>"},{markdown:"---",html:"<hr>"},{markdown:"_________________",html:"<hr>"}],additional_examples:[]},{name:"Images",description:"To add an image, add an exclamation mark (`!`), followed by alt text in brackets, and the path or URL to the image asset in parentheses. You can optionally add a title after the URL in the parentheses.",examples:[{markdown:`![Philadelphia's Magic Gardens. This place was so cool!](/assets/images/philly-magic-gardens.jpg "Philadelphia's Magic Gardens")
`,html:`<img src="/assets/images/philly-magic-garden.jpg" class="img-responsive" alt="Philadelphia's Magic Gardens. This place was so cool!" title="Philadelphia's Magic Gardens">`}],additional_examples:[{name:"Linking Images",description:"To add a link to an image, enclose the Markdown for the image in brackets, and then add the link in parentheses.",markdown:`[![An old rock in the desert](/assets/images/shiprock.jpg "Shiprock, New Mexico by Beau Rogers")](https://images.unsplash.com/photo-1556010334-d6ed191db491?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cm9ja3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60)
`,html:'<a href="https://images.unsplash.com/photo-1556010334-d6ed191db491?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cm9ja3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60" alt="An old rock in the desert" title="Shiprock, New Mexico by Beau Rogers"></a>'}]},{name:"Italic",description:"To italicize text, add one asterisk or underscore before and after a word or phrase. To italicize the middle of a word for emphasis, add one asterisk without spaces around the letters.",examples:[{markdown:"Italicized text is the *cat's meow*.",html:"Italicized text is the <em>cat's meow</em>."},{markdown:"Italicized text is the _cat's meow_.",html:"Italicized text is the <em>cat's meow</em>."},{markdown:"A*cat*meow",html:"A<em>cat</em>meow"}],additional_examples:[]},{name:"Line Breaks",description:"To create a line break (`<br>`), end a line with two or more spaces, and then type return.",examples:[{markdown:`This is the first line.  
And this is the second line.
`,html:"<p>This is the first line.  <br>And this is the second line.</p>"}],additional_examples:[]},{name:"Links",description:"To create a link, enclose the link text in brackets (e.g., `[Duck Duck Go]`) and then follow it immediately with the URL in parentheses (e.g., `(https://duckduckgo.com)`). You can optionally add a title after the URL in the parentheses.",examples:[{markdown:'My favorite search engine is [Duck Duck Go](https://duckduckgo.com "The best search engine for privacy").',html:'My favorite search engine is <a href="https://duckduckgo.com" title="The best search engine for privacy">Duck Duck Go</a>.'}],additional_examples:[{name:"URLs and Email Addresses",description:"To quickly turn a URL or email address into a link, enclose it in angle brackets.",markdown:"<https://www.markdownguide.org><fake@example.com>",html:'<a href="https://www.markdownguide.org">https://www.markdownguide.org</a><a href="&#x6d;&#97;&#105;&#x6c;&#116;&#x6f;&#58;&#x66;&#x61;&#x6b;&#101;&#64;&#x65;&#120;&#x61;&#x6d;&#x70;&#108;&#101;&#46;&#99;&#x6f;&#109;">&#x66;&#x61;&#x6b;&#101;&#64;&#x65;&#120;&#x61;&#x6d;&#x70;&#108;&#101;&#46;&#99;&#x6f;&#109;</a>'},{name:"Formatting Links",description:"To emphasize links, add asterisks before and after the brackets and parentheses.",markdown:"I love supporting **[EFF](https://eff.org)**. This is the *[Markdown Guide](https://www.markdownguide.org)*.",html:'I love supporting <strong><a href="https://eff.org">EFF</a></strong>. This is the <em><a href="https://www.markdownguide.org">Markdown Guide</a></em>.'}]},{name:"Ordered Lists",description:"To create an ordered list, add line items with numbers followed by periods. The numbers don't have to be in numerical order, but the list should start with the number one.",examples:[{markdown:`1. First item
2. Second item
3. Third item
4. Fourth item
`,html:"<ol><li>First item</li><li>Second item</li><li>Third item</li><li>Fourth item</li></ol>"},{markdown:`1. First item
1. Second item
1. Third item
1. Fourth item
`,html:"<ol><li>First item</li><li>Second item</li><li>Third item</li><li>Fourth item</li></ol>"},{markdown:`1. First item
8. Second item
3. Third item
5. Fourth item
`,html:"<ol><li>First item</li><li>Second item</li><li>Third item</li><li>Fourth item</li></ol>"},{markdown:`1. First item
2. Second item
3. Third item
  1. Indented item
  2. Indented item
4. Fourth item
`,html:"<ol><li>First item</li><li>Second item</li><li>Third item<ol><li>Indented item</li><li>Indented item</li></ol></li><li>Fourth item</li></ol>"}],additional_examples:[]},{name:"Paragraphs",description:"To create paragraphs, use a blank line to separate one or more lines of text. You should not indent paragraphs with spaces or tabs.",examples:[{markdown:`I really like using Markdown.

I think I'll use it to format all of my documents from now on.
`,html:"<p>I really like using Markdown.</p><p>I think I'll use it to format all of my documents from now on.</p>"}],additional_examples:[]},{name:"Task Lists",description:"Task lists (also referred to as checklists and todo lists) allow you to create a list of items with checkboxes. In Markdown applications that support task lists, checkboxes will be displayed next to the content. To create a task list, add dashes (-) and brackets with a space ([ ]) in front of task list items. To select a checkbox, add an x in between the brackets ([x]).",examples:[{markdown:`- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media`,html:""}],additional_examples:[]},{name:"Unordered Lists",description:"To create an unordered list, add dashes (`-`), asterisks (`*`), or plus signs (`+`) in front of line items. Indent one or more items to create a nested list.",examples:[{markdown:`- First item
- Second item
- Third item
- Fourth item
`,html:"<ul><li>First item</li><li>Second item</li><li>Third item</li><li>Fourth item</li></ul>"},{markdown:`* First item

* Second item

* Third item

* Fourth item
`,html:"<ul><li>First item</li><li>Second item</li><li>Third item</li><li>Fourth item</li></ul>"},{markdown:`+ First item

* Second item

- Third item

+ Fourth item
`,html:"<ul><li>First item</li><li>Second item</li><li>Third item</li><li>Fourth item</li></ul>"},{markdown:`- First item
- Second item
- Third item

&nbsp;&nbsp;&nbsp;&nbsp;- Indented item

&nbsp;&nbsp;&nbsp;&nbsp;- Indented item
- Fourth item
`,html:"<ul><li>First item</li><li>Second item</li><li>Third item<ul><li>Indented item</li><li>Indented item</li></ul></li><li>Fourth item</li></ul>"}],additional_examples:[]},{name:"Strikethrough",description:"To create a strikethrough effect, add `~~` before and directly after a block of text",examples:[{markdown:"I am ~~unable~~ able to do this!"}],additional_examples:[]},{name:"Tables",description:"Tables are created using pipes, underscored, and hyphens. Hyphens are used to separate rows, and pipes are used to separate columns.",examples:[{markdown:`| Syntax | Description |

| --- | --- |

| Header | Title |

| Paragraph | Text |

`}],additional_examples:[]}],l=v;var r=require("@raycast/api");var _=[[/\*/g,"\\*","asterisks"],[/#/g,"\\#","plus sign"],[/\+/g,"\\+","number signs"],[/\//g,"\\/","slashes"],[/\(/g,"\\(","parentheses"],[/\)/g,"\\)","parentheses"],[/\[/g,"\\[","square brackets"],[/]/g,"\\]","square brackets"],[/</g,"&lt;","angle brackets"],[/>/g,"&gt;","angle brackets"],[/_/g,"\\_","underscores"],[/=/g,"\\=","equals sign"],[/-/g,"\\-","hyphen"]];function d(t,n=[]){return _.reduce((i,a)=>{let e=a[2];return e&&n.indexOf(e)!==-1?i:i.replace(a[0],a[1].toString())},t)}var p=require("react/jsx-runtime"),F=t=>{let{pop:n}=(0,r.useNavigation)(),i=`
   # ${t.name}
   ---
   ${t.description}
   
   ## Examples
   ---
  `;return t.examples.map(a=>{i+=`
${d(a.markdown)}
`}),t.additional_examples.length&&(i+=" ## Additional Examples",t.additional_examples.map(a=>{i+=`
 ## ${a.name}
`,i+=`${a.description}
`,i+=`
${d(a.markdown)}
`})),(0,p.jsx)(r.Detail,{markdown:i,actions:(0,p.jsx)(r.ActionPanel,{children:(0,p.jsx)(r.ActionPanel.Item,{title:"Back",onAction:n})})})},u=F;var s=require("react/jsx-runtime"),I=()=>{let[t,n]=(0,k.useState)(l),{push:i}=(0,o.useNavigation)(),a=e=>{if(e!==""){let m=l.filter(w=>{let h=w.name.toLowerCase().split(" ");return h[0].startsWith(e)||h.length>1&&h[1].startsWith(e)});n(m)}else n(l)};return(0,s.jsx)(o.List,{onSearchTextChange:e=>a(e.toLowerCase()),children:t.length>0&&t.map((e,m)=>(0,s.jsx)(o.List.Item,{title:e.name,actions:(0,s.jsx)(o.ActionPanel,{children:(0,s.jsx)(o.ActionPanel.Item,{title:"View",onAction:()=>i((0,s.jsx)(u,{name:e.name,description:e.description,examples:e.examples,additional_examples:e.additional_examples}))})})},m))})},M=I;0&&(module.exports={});
