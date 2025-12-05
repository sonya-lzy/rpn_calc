import nimib
import std/[strutils, os, strformat]
import times  # 添加这一行

# 初始化Nimib
nbInit

# 设置文档元数据
nbDoc.context["title"] = "现代 C++ 手把手实现 RPN 计算器"
nbDoc.context["author"] = "Your Name"
nbDoc.context["description"] = "从零开始实现一个完整的逆波兰表示法计算器"

# 添加自定义CSS样式
nbRawHtml: """
<style>
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', sans-serif;
    line-height: 1.6;
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
    color: #333;
}
h1, h2, h3 {
    color: #2c3e50;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
}
pre {
    background: #f8f9fa;
    border: 1px solid #e1e4e8;
    border-radius: 4px;
    padding: 16px;
    overflow-x: auto;
}
code {
    font-family: 'SF Mono', Monaco, 'Cascadia Code', Consolas, monospace;
    background: #f8f9fa;
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 0.9em;
}
.meta {
    display: flex;
    gap: 20px;
    margin: 20px 0;
    color: #666;
    font-size: 0.9em;
}
.toc {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin: 30px 0;
}
.chapter {
    border-bottom: 1px solid #eee;
    padding-bottom: 30px;
    margin-bottom: 30px;
}
.chapter:last-child {
    border-bottom: none;
}
.filename {
    background: #2c3e50;
    color: white;
    padding: 10px 15px;
    border-radius: 4px 4px 0 0;
    font-family: 'SF Mono', monospace;
    font-size: 0.9em;
}
.console {
    background: #1a1a1a;
    color: #00ff9d;
    padding: 15px;
    border-radius: 4px;
    font-family: 'SF Mono', monospace;
    margin: 15px 0;
}
.console::before {
    content: "$ ";
}
.note {
    background: #e8f4fd;
    border-left: 4px solid #3498db;
    padding: 15px;
    margin: 20px 0;
    border-radius: 0 4px 4px 0;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
}
th, td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}
th {
    background: #f2f2f2;
}
.badge {
    display: inline-block;
    background: #3498db;
    color: white;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.8em;
    margin-right: 8px;
    margin-bottom: 8px;
}
</style>
"""

# 文档标题和元数据
nbText: """
# 现代 C++ 手把手实现 RPN 计算器

**从零开始实现一个完整的逆波兰表示法计算器**

<div class="meta">
    <div><strong>版本:</strong> 1.0</div>
    <div><strong>编译器:</strong> GCC 10+/Clang 12+/MSVC 2019+</div>
    <div><strong>标准:</strong> C++17</div>
</div>

<div>
    <span class="badge">RPN</span>
    <span class="badge">C++17</span>
    <span class="badge">STL</span>
    <span class="badge">算法</span>
    <span class="badge">命令行</span>
    <span class="badge">开源</span>
</div>
"""

# 目录
nbText: """
<div class="toc">
    <h2>目录</h2>
    <ol>
        <li><a href="#chapter1">第 1 章: Hello RPN</a></li>
        <li><a href="#chapter2">第 2 章: 头文件化 + 单元测试</a></li>
        <li><a href="#chapter3">第 3 章: 交互式 REPL</a></li>
        <li><a href="#chapter4">第 4 章: 单文件发布 & 交叉编译</a></li>
        <li><a href="#chapter5">第 5 章: 扩展功能与挑战</a></li>
    </ol>
</div>
"""

# 第1章
nbText: """
<div class="chapter" id="chapter1">
    <h2>第 1 章: Hello RPN</h2>
    
    <p>我们先从一个最小可运行的 RPN 计算器开始，理解逆波兰表示法的核心思想。</p>
    
    <div class="note">
        <p><strong>RPN 简介</strong></p>
        <p>逆波兰表示法（Reverse Polish Notation）是一种不需要括号的数学表达式表示法，所有运算符都跟在操作数后面。</p>
        <p>示例：<code>3 4 +</code> 表示 <code>3 + 4</code>，<code>3 4 + 5 *</code> 表示 <code>(3 + 4) * 5</code></p>
    </div>
</div>
"""

# 添加代码块
nbText: """<div class="filename">rpn_min.cpp</div>"""
nbCode:
  echo """#include <iostream>
#include <sstream>
#include <stack>
#include <string>
#include <stdexcept>

double rpn_evaluate(const std::string& expression) {
    std::stack<double> stack;
    std::istringstream iss(expression);
    std::string token;
    
    while (iss >> token) {
        if (token.size() == 1 && std::string("+-*/").find(token[0]) != std::string::npos) {
            if (stack.size() < 2) {
                throw std::runtime_error("Error: insufficient operands");
            }
            
            double b = stack.top(); stack.pop();
            double a = stack.top(); stack.pop();
            
            switch (token[0]) {
                case '+': stack.push(a + b); break;
                case '-': stack.push(a - b); break;
                case '*': stack.push(a * b); break;
                case '/': 
                    if (b == 0) throw std::runtime_error("Error: division by zero");
                    stack.push(a / b); 
                    break;
            }
        } else {
            try {
                stack.push(std::stod(token));
            } catch (const std::invalid_argument&) {
                throw std::runtime_error("Error: invalid token '" + token + "'");
            }
        }
    }
    
    if (stack.size() != 1) {
        throw std::runtime_error("Error: expression invalid");
    }
    
    return stack.top();
}

int main() {
    std::string expression;
    std::cout << "Enter RPN expression: ";
    std::getline(std::cin, expression);
    
    try {
        double result = rpn_evaluate(expression);
        std::cout << "Result: " << result << std::endl;
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}"""

# 编译命令
nbText: """
<div class="console">g++ -std=c++17 -o rpn_min rpn_min.cpp && ./rpn_min</div>

<div class="note">
    <p><strong>本章要点</strong></p>
    <ul>
        <li>理解 RPN 的基本原理</li>
        <li>使用 <code>std::stack</code> 实现计算</li>
        <li>基本的错误处理机制</li>
    </ul>
</div>
"""

# 第2章
nbText: """
<div class="chapter" id="chapter2">
    <h2>第 2 章: 头文件化 + 单元测试</h2>
    
    <p>将核心逻辑封装成头文件，并添加单元测试确保正确性。</p>
</div>
"""

nbText: """<div class="filename">rpn_engine.hpp</div>"""
nbCode:
  echo """#pragma once

#include <stack>
#include <sstream>
#include <string>
#include <stdexcept>
#include <cmath>

class RPNEngine {
public:
    static double evaluate(const std::string& expression) {
        std::stack<double> stack;
        std::istringstream iss(expression);
        std::string token;
        
        while (iss >> token) {
            if (is_operator(token)) {
                if (stack.size() < 2) {
                    throw std::runtime_error("Insufficient operands");
                }
                
                double b = stack.top(); stack.pop();
                double a = stack.top(); stack.pop();
                apply_operator(stack, token, a, b);
            } 
            else if (is_function(token)) {
                if (stack.empty()) {
                    throw std::runtime_error("No operand for function");
                }
                
                double a = stack.top(); stack.pop();
                apply_function(stack, token, a);
            }
            else {
                try {
                    stack.push(std::stod(token));
                } catch (const std::invalid_argument&) {
                    throw std::runtime_error("Invalid token: " + token);
                }
            }
        }
        
        if (stack.size() != 1) {
            throw std::runtime_error("Invalid expression");
        }
        
        return stack.top();
    }

private:
    static bool is_operator(const std::string& token) {
        if (token.size() != 1) return false;
        char op = token[0];
        return op == '+' || op == '-' || op == '*' || op == '/' || op == '^';
    }
    
    static bool is_function(const std::string& token) {
        return token == "sqrt" || token == "sin" || token == "cos" || token == "log";
    }
    
    static void apply_operator(std::stack<double>& stack, const std::string& op, 
                              double a, double b) {
        switch (op[0]) {
            case '+': stack.push(a + b); break;
            case '-': stack.push(a - b); break;
            case '*': stack.push(a * b); break;
            case '/': 
                if (b == 0) throw std::runtime_error("Division by zero");
                stack.push(a / b); 
                break;
            case '^': stack.push(std::pow(a, b)); break;
        }
    }
    
    static void apply_function(std::stack<double>& stack, const std::string& func, 
                              double a) {
        if (func == "sqrt") {
            if (a < 0) throw std::runtime_error("Square root of negative number");
            stack.push(std::sqrt(a));
        } else if (func == "sin") {
            stack.push(std::sin(a));
        } else if (func == "cos") {
            stack.push(std::cos(a));
        } else if (func == "log") {
            if (a <= 0) throw std::runtime_error("Logarithm of non-positive number");
            stack.push(std::log(a));
        }
    }
};"""

# 第3章
nbText: """
<div class="chapter" id="chapter3">
    <h2>第 3 章: 交互式 REPL</h2>
    
    <p>实现一个完整的交互式计算器，支持历史记录和命令补全。</p>
</div>
"""

nbText: """<div class="filename">repl.cpp</div>"""
nbCode:
  echo """#include "rpn_engine.hpp"
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>

class REPL {
private:
    std::vector<std::string> history;
    
    void print_help() {
        std::cout << "\n=== RPN Calculator Commands ===\n";
        std::cout << "  <expression>    Evaluate RPN expression\n";
        std::cout << "  help            Show this help message\n";
        std::cout << "  history         Show calculation history\n";
        std::cout << "  clear           Clear the screen\n";
        std::cout << "  quit / exit     Exit the program\n";
        std::cout << "\nOperators: + - * / ^\n";
        std::cout << "Functions: sqrt sin cos log\n";
        std::cout << "Example: '5 5 + 3 *' => 30\n";
        std::cout << "==============================\n";
    }
    
    void print_history() {
        if (history.empty()) {
            std::cout << "No history yet.\n";
            return;
        }
        
        std::cout << "\n=== Calculation History ===\n";
        for (size_t i = 0; i < history.size(); ++i) {
            std::cout << i + 1 << ". " << history[i] << "\n";
        }
        std::cout << "===========================\n";
    }

public:
    void run() {
        std::cout << "RPN Calculator REPL (Type 'help' for commands)\n";
        std::cout << "==============================================\n\n";
        
        std::string line;
        while (true) {
            std::cout << "rpn> ";
            if (!std::getline(std::cin, line)) break;
            
            line.erase(0, line.find_first_not_of(" \t\n\r"));
            line.erase(line.find_last_not_of(" \t\n\r") + 1);
            
            if (line.empty()) continue;
            
            if (line == "quit" || line == "exit") {
                std::cout << "Goodbye!\n";
                break;
            } else if (line == "help") {
                print_help();
                continue;
            } else if (line == "history") {
                print_history();
                continue;
            } else if (line == "clear") {
                for (int i = 0; i < 50; ++i) std::cout << "\n";
                continue;
            }
            
            try {
                double result = RPNEngine::evaluate(line);
                std::cout << "= " << std::setprecision(12) << result << "\n";
                history.push_back(line + " => " + std::to_string(result));
            } catch (const std::exception& e) {
                std::cout << "Error: " << e.what() << "\n";
            }
        }
    }
};

int main() {
    REPL repl;
    repl.run();
    return 0;
}"""

# 第4章
nbText: """
<div class="chapter" id="chapter4">
    <h2>第 4 章: 单文件发布 & 交叉编译</h2>
    
    <p>将整个项目打包成单个文件，并支持跨平台编译。</p>
"""

# 添加表格
nbRawHtml: """
<table>
    <tr>
        <th>平台</th>
        <th>编译命令</th>
        <th>文件大小</th>
    </tr>
    <tr>
        <td>Linux/macOS</td>
        <td><code>g++ -std=c++17 -O3 -o rpn rpn_single.cpp</code></td>
        <td>~92 KB</td>
    </tr>
    <tr>
        <td>Windows (MinGW)</td>
        <td><code>x86_64-w64-mingw32-g++ -std=c++17 -O3 -o rpn.exe rpn_single.cpp</code></td>
        <td>~85 KB</td>
    </tr>
</table>
"""

nbText: """
<div class="console"># 下载完整项目
git clone https://github.com/sonya-lzy/rpn_calc.git
cd rpn_calc

# 编译并运行
g++ -std=c++17 -o rpn src/rpn_calc.cpp
./rpn</div>
"""

# 第5章
nbText: """
<div class="chapter" id="chapter5">
    <h2>第 5 章: 扩展功能与挑战</h2>
    
    <div class="note">
        <p><strong>扩展挑战</strong></p>
        <ol>
            <li><strong>复数支持</strong>：扩展支持复数运算</li>
            <li><strong>变量存储</strong>：实现变量赋值和使用</li>
            <li><strong>脚本模式</strong>：支持从文件读取表达式</li>
            <li><strong>图形界面</strong>：使用 Qt 或 ImGUI 添加 GUI</li>
            <li><strong>网络计算</strong>：实现客户端-服务器模式</li>
        </ol>
    </div>
    
    <p>
        <strong>GitHub 仓库:</strong> <a href="https://github.com/sonya-lzy/rpn_calc">https://github.com/sonya-lzy/rpn_calc</a><br>
        <strong>在线文档:</strong> <a href="https://sonya-lzy.github.io/rpn_calc/rpn_manual.html">https://sonya-lzy.github.io/rpn_calc/rpn_manual.html</a>
    </p>
</div>
"""

# 页脚
nbText: fmt"""
<hr>
<p style="text-align: center; color: #666; font-size: 0.9em;">
    © 2024 RPN Calculator Project | C++ 编程作业<br>
    生成时间: {getTime().format("yyyy-MM-dd HH:mm:ss")}
</p>
"""

# 保存文档
nbsave()

echo "✅ Nimib文档已生成: rpn_manual.html"
