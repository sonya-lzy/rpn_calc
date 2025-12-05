import nimib

template initCodeTheme* =
  nb.context["stylesheet"] = """
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">"""
  
  nb.context["highlight"] = """
<link rel="stylesheet" media="(prefers-color-scheme: dark)"
  href="https://cdn.jsdelivr.net/gh/highlightjs/highlight.js/src/styles/night-owl.css">
<link rel="stylesheet" media="(prefers-color-scheme: light), (prefers-color-scheme: no-preference)"
  href="https://cdn.jsdelivr.net/gh/highlightjs/highlight.js/src/styles/atom-one-light.css">"""

  nbRawHtml: """
<style>
pre code { border-radius: 4px 4px 0 0; }
pre { 
    border: 1px solid #809eb7; 
    border-radius: 4px 4px 0 0; 
    margin-bottom: 0; 
    padding: 16px; 
    overflow-x: auto;
}
pre.nb-output { 
    border: 1px solid #809eb7; 
    border-radius: 0 0 8px 8px; 
    border-top: none;
    padding: 0.8em; 
    margin-top: 0; 
    overflow-x: auto; 
}
code {
    font-family: 'SF Mono', Monaco, 'Cascadia Code', Consolas, monospace;
    font-size: 0.9em;
}
</style>
"""
