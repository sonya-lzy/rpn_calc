## RPN (逆波兰表示法) 计算器 - 完整实现
## 
## 这个文件包含完整的RPN计算器实现，包括：
## - RPNCalculator类型和所有操作
## - 交互式命令行界面
## - HTML文档生成功能

import std/[strutils, math, sequtils, strformat, os, times]

type
  RPNCalculator* = object
    ## RPN计算器对象
    stack*: seq[float]
    history*: seq[string]

proc initRPNCalculator*(): RPNCalculator =
  ## 初始化并返回一个新的RPN计算器实例
  RPNCalculator(stack: @[], history: @[])

proc push*(calc: var RPNCalculator, value: float) =
  ## 将数值推入栈顶
  calc.stack.add(value)

proc pop*(calc: var RPNCalculator): float =
  ## 从栈顶弹出并返回一个值
  if calc.stack.len == 0:
    raise newException(ValueError, "错误: 栈为空")
  result = calc.stack[^1]
  calc.stack.setLen(calc.stack.len - 1)

proc clear*(calc: var RPNCalculator) =
  ## 清空计算器栈
  calc.stack.setLen(0)

proc displayStack*(calc: RPNCalculator) =
  ## 显示当前栈状态
  stdout.write "当前栈: "
  if calc.stack.len == 0:
    echo "空"
  else:
    for i in countdown(calc.stack.high, 0):
      stdout.write &"{calc.stack[i]:.6f} "
    echo ""

proc fibonacci*(n: int): float =
  ## 计算斐波那契数列的第n项
  if n == 0:
    return 0.0
  if n == 1:
    return 1.0
  
  var a = 0.0
  var b = 1.0
  var c: float
  
  for i in 2..n:
    c = a + b
    a = b
    b = c
  
  return b

proc calculate*(calc: var RPNCalculator, operation: string) =
  ## 执行指定的计算操作
  case operation
  of "+":
    if calc.stack.len < 2:
      raise newException(ValueError, "错误: 栈元素不足")
    let b = calc.pop()
    let a = calc.pop()
    calc.push(a + b)
  
  of "-":
    if calc.stack.len < 2:
      raise newException(ValueError, "错误: 栈元素不足")
    let b = calc.pop()
    let a = calc.pop()
    calc.push(a - b)
  
  of "*":
    if calc.stack.len < 2:
      raise newException(ValueError, "错误: 栈元素不足")
    let b = calc.pop()
    let a = calc.pop()
    calc.push(a * b)
  
  of "/":
    if calc.stack.len < 2:
      raise newException(ValueError, "错误: 栈元素不足")
    let b = calc.pop()
    if b == 0.0:
      raise newException(ValueError, "错误: 除零错误")
    let a = calc.pop()
    calc.push(a / b)
  
  of "sqrt":
    if calc.stack.len < 1:
      raise newException(ValueError, "错误: 栈为空")
    let a = calc.pop()
    if a < 0.0:
      raise newException(ValueError, "错误: 负数不能开平方根")
    calc.push(sqrt(a))
  
  of "pow":
    if calc.stack.len < 2:
      raise newException(ValueError, "错误: 栈元素不足")
    let exponent = calc.pop()
    let base = calc.pop()
    calc.push(pow(base, exponent))
  
  of "sin":
    if calc.stack.len < 1:
      raise newException(ValueError, "错误: 栈为空")
    let a = calc.pop()
    calc.push(sin(a * PI / 180.0))
  
  of "cos":
    if calc.stack.len < 1:
      raise newException(ValueError, "错误: 栈为空")
    let a = calc.pop()
    calc.push(cos(a * PI / 180.0))
  
  of "fib":
    if calc.stack.len < 1:
      raise newException(ValueError, "错误: 栈为空")
    let n = calc.pop()
    if n < 0.0 or n != float(int(n)):
      raise newException(ValueError, "错误: 斐波那契数列需要非负整数")
    calc.push(fibonacci(int(n)))
  
  of "clear":
    calc.clear()
  
  of "display":
    calc.displayStack()
  
  else:
    raise newException(ValueError, &"错误: 未知操作符 '{operation}'")

proc processExpression*(calc: var RPNCalculator, expression: string) =
  ## 处理RPN表达式字符串
  let tokens = expression.strip().splitWhitespace()
  
  for token in tokens:
    if token == "q":
      return
    
    try:
      let number = parseFloat(token)
      calc.push(number)
    except ValueError:
      try:
        calc.calculate(token)
      except ValueError as e:
        echo e.msg
        return
  
  if calc.stack.len > 0:
    let result = calc.stack[^1]
    echo &"结果: {result:.6f}"
    calc.history.add(&"{expression} = {result:.6f}")

proc showHistory*(calc: RPNCalculator) =
  ## 显示计算历史记录
  echo "计算历史:"
  if calc.history.len == 0:
    echo "  无历史记录"
  else:
    for i, entry in calc.history:
      echo &"  {i + 1}. {entry}"

proc showHelp*() =
  ## 显示使用说明和帮助信息
  echo "=== RPN计算器使用说明 ==="
  echo "基本操作: +, -, *, /"
  echo "数学函数: sqrt, pow, sin, cos"
  echo "特殊功能: fib (斐波那契数列)"
  echo "栈操作: clear (清空), display (显示栈)"
  echo "系统命令: history (历史), help (帮助), q (退出)"
  echo "文档命令: export (生成HTML文档)"
  echo ""
  echo "使用示例:"
  echo "  输入: '5 5 + 3 *' 得到结果 30.0"
  echo "  输入: '2 3 pow' 计算 2^3 = 8.0"
  echo "  输入: '9 sqrt' 计算 √9 = 3.0"
  echo "========================="

proc generateHTMLDocument*(calc: RPNCalculator, filename: string = "rpn_calculator.html") =
  ## 生成HTML格式的文档和状态报告
  let currentTime = now().format("yyyy-MM-dd HH:mm:ss")
  var html = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RPN计算器状态报告</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
            text-align: center;
        }
        .header h1 {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .header .subtitle {
            color: #7f8c8d;
            font-size: 1.2em;
        }
        .card {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .card h2 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-bottom: 15px;
            font-size: 1.8em;
        }
        .stack-display {
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 20px;
            font-family: 'Courier New', monospace;
            font-size: 1.1em;
            min-height: 60px;
        }
        .stack-empty {
            color: #6c757d;
            font-style: italic;
        }
        .history-list {
            list-style: none;
        }
        .history-item {
            background: #f8f9fa;
            margin: 8px 0;
            padding: 12px 15px;
            border-radius: 8px;
            border-left: 4px solid #3498db;
            transition: transform 0.2s;
        }
        .history-item:hover {
            transform: translateX(5px);
            background: #e9ecef;
        }
        .history-index {
            font-weight: bold;
            color: #3498db;
        }
        .usage-examples {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        .example {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #2196f3;
        }
        .example h4 {
            color: #1976d2;
            margin-bottom: 8px;
        }
        .footer {
            text-align: center;
            color: white;
            margin-top: 30px;
            opacity: 0.8;
        }
        .timestamp {
            color: #7f8c8d;
            font-size: 0.9em;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>RPN计算器状态报告</h1>
            <div class="subtitle">逆波兰表示法计算器 - 实时状态和历史记录</div>
            <div class="timestamp">生成时间: """ & currentTime & """</div>
        </div>
        
        <div class="card">
            <h2>📊 当前栈状态</h2>
            <div class="stack-display">
  """
  
  if calc.stack.len == 0:
    html &= "<div class='stack-empty'>栈为空</div>"
  else:
    html &= "<div><strong>栈顶 → 栈底:</strong></div><div style='margin-top: 10px;'>"
    for i in countdown(calc.stack.high, 0):
      html &= &"<span style='display: inline-block; background: #3498db; color: white; padding: 5px 10px; margin: 2px; border-radius: 5px;'>{calc.stack[i]:.6f}</span> "
    html &= "</div>"
  
  html &= """
            </div>
        </div>
        
        <div class="card">
            <h2>📝 计算历史</h2>
  """
  
  if calc.history.len == 0:
    html &= "<div class='stack-empty'>暂无计算历史</div>"
  else:
    html &= "<ul class='history-list'>"
    for i, entry in calc.history:
      html &= &"<li class='history-item'><span class='history-index'>{i + 1}.</span> {entry}</li>"
    html &= "</ul>"
  
  html &= """
        </div>
        
        <div class="card">
            <h2>🎯 使用指南</h2>
            <div class="usage-examples">
                <div class="example">
                    <h4>基本运算</h4>
                    <p><code>5 5 +</code> → 加法</p>
                    <p><code>10 3 -</code> → 减法</p>
                    <p><code>4 5 *</code> → 乘法</p>
                    <p><code>20 4 /</code> → 除法</p>
                </div>
                <div class="example">
                    <h4>数学函数</h4>
                    <p><code>9 sqrt</code> → 平方根</p>
                    <p><code>2 3 pow</code> → 幂运算</p>
                    <p><code>30 sin</code> → 正弦</p>
                    <p><code>10 fib</code> → 斐波那契</p>
                </div>
                <div class="example">
                    <h4>栈操作</h4>
                    <p><code>clear</code> → 清空栈</p>
                    <p><code>display</code> → 显示栈</p>
                    <p><code>history</code> → 查看历史</p>
                    <p><code>help</code> → 获取帮助</p>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h2>ℹ️ 关于RPN</h2>
            <p><strong>逆波兰表示法 (Reverse Polish Notation)</strong> 是一种数学表达式方式，运算符位于操作数之后。</p>
            <p>例如：普通表达式 <code>3 + 4</code> 在RPN中写作 <code>3 4 +</code></p>
            <p>优势：不需要括号，易于计算机实现栈运算。</p>
        </div>
    </div>
    
    <div class="footer">
        <p>Generated by Nim RPN Calculator | 2024</p>
    </div>
</body>
</html>
  """
  
  writeFile(filename, html)
  echo &"✅ HTML文档已生成: {filename}"

when isMainModule:
  ## 主程序入口点
  var calc = initRPNCalculator()
  
  echo "Nim RPN 计算器"
  echo "输入表达式（例如：'5 5 +'），或输入 'help' 查看帮助，'q' 退出。"
  
  while true:
    stdout.write "> "
    let input = stdin.readLine().strip()
    
    case input
    of "q", "quit":
      break
    of "help":
      showHelp()
    of "history":
      calc.showHistory()
    of "clear":
      calc.clear()
      echo "栈已清空"
    of "export":
      calc.generateHTMLDocument()
    else:
      if input.len > 0:
        calc.processExpression(input)
  
  echo "感谢使用RPN计算器！"
