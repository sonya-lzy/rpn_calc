## RPN计算器使用手册 - 精简版
import nimib
import std/[strutils, strformat, times]

nbInit

nbDoc.context["title"] = "RPN计算器使用手册"
nbDoc.context["author"] = "您的姓名"

nbText: """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RPN计算器使用手册</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
            background: #f5f5f5;
        }
        .container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
            text-align: center;
        }
        h2 {
            color: #2980b9;
            border-left: 4px solid #3498db;
            padding-left: 10px;
            margin-top: 30px;
        }
        h3 {
            color: #34495e;
        }
        code {
            background: #f8f9fa;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            color: #c7254e;
        }
        pre {
            background: #2c3e50;
            color: #ecf0f1;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            font-size: 14px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background: #f2f2f2;
            color: #2c3e50;
        }
        .note {
            background: #e8f4fd;
            border-left: 4px solid #3498db;
            padding: 15px;
            margin: 15px 0;
        }
        .error {
            background: #fde8e8;
            border-left: 4px solid #e74c3c;
            padding: 15px;
            margin: 15px 0;
        }
        .success {
            background: #e8f8ef;
            border-left: 4px solid #27ae60;
            padding: 15px;
            margin: 15px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>RPN计算器使用手册</h1>
        <p><strong>项目简介：</strong>这是一个用C++实现的逆波兰表示法(RPN)计算器，支持基本运算、数学函数和历史记录功能。</p>
    </div>
"""

nbText: """
    <div class="container">
        <h2>📦 安装和编译指南</h2>
        
        <h3>环境要求</h3>
        <ul>
            <li>GCC/G++ 编译器（版本 5.0+）</li>
            <li>支持C++11标准</li>
        </ul>
        
        <h3>编译命令</h3>
        <pre>g++ -std=c++11 -o rpn_calc rpn_calc.cpp</pre>
        
        <h3>使用Makefile</h3>
        <pre>cd src
make        # 编译
make run    # 编译并运行
make clean  # 清理</pre>
    </div>
"""

nbText: """
    <div class="container">
        <h2>🚀 基本使用示例</h2>
        
        <h3>启动程序</h3>
        <pre>./rpn_calc</pre>
        
        <h3>交互示例</h3>
        <pre>C++ RPN 计算器
输入表达式（例，'5 5 +'），或输入 'help' 查看帮助，'q' 退出。
> 5 5 +
结果: 10.000000
> 3 *
结果: 30.000000
> q
感谢使用RPN计算器！</pre>
        
        <div class="success">
            <strong>示例1：</strong> <code>5 5 + 3 *</code> → 结果: 30.0<br>
            <strong>示例2：</strong> <code>2 3 pow</code> → 结果: 8.0<br>
            <strong>示例3：</strong> <code>9 sqrt</code> → 结果: 3.0
        </div>
    </div>
"""

nbText: """
    <div class="container">
        <h2>🔧 支持的操作说明</h2>
        
        <h3>基本算术运算</h3>
        <table>
            <tr><th>操作符</th><th>描述</th><th>示例</th><th>结果</th></tr>
            <tr><td><code>+</code></td><td>加法</td><td><code>5 5 +</code></td><td>10</td></tr>
            <tr><td><code>-</code></td><td>减法</td><td><code>10 3 -</code></td><td>7</td></tr>
            <tr><td><code>*</code></td><td>乘法</td><td><code>4 5 *</code></td><td>20</td></tr>
            <tr><td><code>/</code></td><td>除法</td><td><code>20 4 /</code></td><td>5</td></tr>
        </table>
        
        <h3>数学函数</h3>
        <table>
            <tr><th>函数</th><th>描述</th><th>示例</th><th>结果</th></tr>
            <tr><td><code>sqrt</code></td><td>平方根</td><td><code>9 sqrt</code></td><td>3</td></tr>
            <tr><td><code>pow</code></td><td>幂运算</td><td><code>2 3 pow</code></td><td>8</td></tr>
            <tr><td><code>sin</code></td><td>正弦(角度)</td><td><code>30 sin</code></td><td>0.5</td></tr>
            <tr><td><code>cos</code></td><td>余弦(角度)</td><td><code>60 cos</code></td><td>0.5</td></tr>
        </table>
        
        <h3>特殊功能</h3>
        <table>
            <tr><th>操作符</th><th>描述</th><th>示例</th><th>结果</th></tr>
            <tr><td><code>fib</code></td><td>斐波那契数列</td><td><code>10 fib</code></td><td>55</td></tr>
        </table>
        
        <h3>系统命令</h3>
        <ul>
            <li><code>help</code> - 显示帮助信息</li>
            <li><code>history</code> - 显示计算历史</li>
            <li><code>clear</code> - 清空栈</li>
            <li><code>q</code> - 退出程序</li>
        </ul>
    </div>
"""

nbText: """
    <div class="container">
        <h2>⚠️ 错误代码和异常说明</h2>
        
        <div class="error">
            <strong>错误: 栈为空</strong><br>
            原因：当栈中没有元素时尝试执行操作<br>
            示例：<code>+</code>（栈为空时）<br>
            解决方案：确保栈中有足够元素
        </div>
        
        <div class="error">
            <strong>错误: 除零错误</strong><br>
            原因：尝试除以零<br>
            示例：<code>5 0 /</code><br>
            解决方案：检查除数是否为0
        </div>
        
        <div class="error">
            <strong>错误: 栈元素不足</strong><br>
            原因：操作需要更多操作数<br>
            示例：<code>+</code>（栈中只有一个元素）<br>
            解决方案：确保栈中有足够操作数
        </div>
        
        <div class="error">
            <strong>错误: 未知操作符</strong><br>
            原因：输入了不支持的操作符<br>
            示例：<code>5 5 &</code><br>
            解决方案：使用支持的操作符
        </div>
        
        <div class="error">
            <strong>错误: 负数不能开平方根</strong><br>
            原因：尝试对负数计算平方根<br>
            示例：<code>-9 sqrt</code><br>
            解决方案：确保被开方数为非负数
        </div>
    </div>
"""

nbText: """
    <div class="container">
        <h2>📝 示例输入输出</h2>
        
        <h3>测试用例1：作业要求示例</h3>
        <pre>输入: 1 2 + 3 + 7 7 * +
输出: 结果: 55.000000</pre>
        
        <h3>测试用例2：混合运算</h3>
        <pre>输入: 10 2 / 3 + 4 * 2 -
输出: 结果: 26.000000</pre>
        
        <h3>测试用例3：函数使用</h3>
        <pre>输入: 9 sqrt 2 3 pow +
输出: 结果: 11.000000</pre>
        
        <h3>测试用例4：错误处理</h3>
        <pre>输入: 5 0 /
输出: 错误: 除零错误</pre>
        
        <h3>测试用例5：历史记录</h3>
        <pre>输入: 5 5 +
输出: 结果: 10.000000
输入: history
输出: 计算历史:
1. 加法: 5.000000 + 5.000000</pre>
    </div>
"""

nbText: """
    <div class="container">
        <h2>📂 项目信息</h2>
        
        <h3>项目结构</h3>
        <pre>rpn_calc/
├── src/
│   ├── rpn_calc.cpp
│   └── Makefile
├── docs/
│   ├── rpn_manual.nim
│   └── rpn_manual.html
└── README.md</pre>
        
        <h3>GitHub仓库</h3>
        <p><a href="https://github.com/sonya-lzy/rpn_calc">https://github.com/sonya-lzy/rpn_calc</a></p>
        
        <h3>在线文档</h3>
        <p><a href="https://sonya-lzy.github.io/rpn_calc/rpn_manual.html">https://sonya-lzy.github.io/rpn_calc/rpn_manual.html</a></p>
        
        <h3>许可证</h3>
        <p>MIT License</p>
        
        <hr>
        <p style="text-align: center; color: #666;">
            <strong>文档生成时间</strong>: """ & now().format("yyyy-MM-dd HH:mm:ss") & """<br>
            <strong>版本</strong>: 1.0.0<br>
            <strong>作者</strong>: zyy
        </p>
    </div>
</body>
</html>
"""
nbSave
