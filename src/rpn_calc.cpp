#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cmath>
#include <stack>
#include <stdexcept>
#include <map>
#include <iomanip>

class RPNCalculator {
private:
    std::vector<double> stack;
    std::vector<std::string> history;

public:
    // 基本栈操作
    void push(double value) {
        stack.push_back(value);
    }

    double pop() {
        if (stack.empty()) {
            throw std::runtime_error("错误: 栈为空");
        }
        double value = stack.back();
        stack.pop_back();
        return value;
    }

    void clear() {
        stack.clear();
    }

    void displayStack() {
        std::cout << "当前栈: ";
        if (stack.empty()) {
            std::cout << "空";
        } else {
            for (int i = stack.size() - 1; i >= 0; --i) {
                std::cout << std::fixed << std::setprecision(6) << stack[i] << " ";
            }
        }
        std::cout << std::endl;
    }

    // 计算操作
    void calculate(const std::string& operation) {
        if (operation == "+") {
            if (stack.size() < 2) throw std::runtime_error("错误: 栈元素不足");
            double b = pop();
            double a = pop();
            push(a + b);
            history.push_back("加法: " + std::to_string(a) + " + " + std::to_string(b));
            
        } else if (operation == "-") {
            if (stack.size() < 2) throw std::runtime_error("错误: 栈元素不足");
            double b = pop();
            double a = pop();
            push(a - b);
            history.push_back("减法: " + std::to_string(a) + " - " + std::to_string(b));
            
        } else if (operation == "*") {
            if (stack.size() < 2) throw std::runtime_error("错误: 栈元素不足");
            double b = pop();
            double a = pop();
            push(a * b);
            history.push_back("乘法: " + std::to_string(a) + " * " + std::to_string(b));
            
        } else if (operation == "/") {
            if (stack.size() < 2) throw std::runtime_error("错误: 栈元素不足");
            double b = pop();
            if (b == 0) throw std::runtime_error("错误: 除零错误");
            double a = pop();
            push(a / b);
            history.push_back("除法: " + std::to_string(a) + " / " + std::to_string(b));
            
        } else if (operation == "sqrt") {
            if (stack.empty()) throw std::runtime_error("错误: 栈为空");
            double a = pop();
            if (a < 0) throw std::runtime_error("错误: 负数不能开平方根");
            push(std::sqrt(a));
            history.push_back("平方根: sqrt(" + std::to_string(a) + ")");
            
        } else if (operation == "pow") {
            if (stack.size() < 2) throw std::runtime_error("错误: 栈元素不足");
            double exponent = pop();
            double base = pop();
            push(std::pow(base, exponent));
            history.push_back("幂运算: " + std::to_string(base) + " ^ " + std::to_string(exponent));
            
        } else if (operation == "sin") {
            if (stack.empty()) throw std::runtime_error("错误: 栈为空");
            double a = pop();
            push(std::sin(a * M_PI / 180.0)); // 转换为弧度
            history.push_back("正弦: sin(" + std::to_string(a) + "°)");
            
        } else if (operation == "cos") {
            if (stack.empty()) throw std::runtime_error("错误: 栈为空");
            double a = pop();
            push(std::cos(a * M_PI / 180.0));
            history.push_back("余弦: cos(" + std::to_string(a) + "°)");
            
        } else if (operation == "fib") {
            if (stack.empty()) throw std::runtime_error("错误: 栈为空");
            double n = pop();
            if (n < 0 || n != static_cast<int>(n)) 
                throw std::runtime_error("错误: 斐波那契数列需要非负整数");
            push(fibonacci(static_cast<int>(n)));
            history.push_back("斐波那契: fib(" + std::to_string(static_cast<int>(n)) + ")");
            
        } else if (operation == "clear") {
            clear();
            history.push_back("清空栈");
            
        } else if (operation == "display") {
            displayStack();
            
        } else {
            throw std::runtime_error("错误: 未知操作符 '" + operation + "'");
        }
    }

    // 斐波那契数列计算
    double fibonacci(int n) {
        if (n == 0) return 0;
        if (n == 1) return 1;
        
        double a = 0, b = 1, c;
        for (int i = 2; i <= n; i++) {
            c = a + b;
            a = b;
            b = c;
        }
        return b;
    }

    // 处理表达式
    void processExpression(const std::string& expression) {
        std::istringstream iss(expression);
        std::string token;
        
        while (iss >> token) {
            if (token == "q") {
                return;
            }
            
            // 检查是否为数字
            std::istringstream tokenStream(token);
            double number;
            if (tokenStream >> number && tokenStream.eof()) {
                push(number);
            } else {
                // 是操作符或命令
                try {
                    calculate(token);
                } catch (const std::exception& e) {
                    std::cout << e.what() << std::endl;
                    return;
                }
            }
        }
        
        // 显示最终结果
        if (!stack.empty()) {
            std::cout << "结果: " << std::fixed << std::setprecision(6) << stack.back() << std::endl;
        }
    }

    // 显示历史
    void showHistory() {
        std::cout << "计算历史:" << std::endl;
        if (history.empty()) {
            std::cout << "  无历史记录" << std::endl;
        } else {
            for (size_t i = 0; i < history.size(); ++i) {
                std::cout << i + 1 << ". " << history[i] << std::endl;
            }
        }
    }

    // 显示帮助
    void showHelp() {
        std::cout << "=== RPN计算器使用说明 ===" << std::endl;
        std::cout << "基本操作: +, -, *, /" << std::endl;
        std::cout << "数学函数: sqrt, pow, sin, cos" << std::endl;
        std::cout << "特殊功能: fib (斐波那契数列)" << std::endl;
        std::cout << "栈操作: clear (清空), display (显示栈)" << std::endl;
        std::cout << "系统命令: history (历史), help (帮助), q (退出)" << std::endl;
        std::cout << "" << std::endl;
        std::cout << "使用示例: " << std::endl;
        std::cout << "  输入: '5 5 + 3 *' 得到结果 30" << std::endl;
        std::cout << "  输入: '2 3 pow' 计算 2^3 = 8" << std::endl;
        std::cout << "  输入: '9 sqrt' 计算 √9 = 3" << std::endl;
        std::cout << "=========================" << std::endl;
    }
};

int main() {
    RPNCalculator calc;
    std::string input;
    
    std::cout << "C++ RPN 计算器" << std::endl;
    std::cout << "输入表达式（例，'5 5 +'），或输入 'help' 查看帮助，'q' 退出。" << std::endl;
    
    while (true) {
        std::cout << "> ";
        std::getline(std::cin, input);
        
        if (input == "q" || input == "quit") {
            break;
        } else if (input == "help") {
            calc.showHelp();
        } else if (input == "history") {
            calc.showHistory();
        } else if (input == "clear") {
            calc.clear();
            std::cout << "栈已清空" << std::endl;
        } else if (!input.empty()) {
            calc.processExpression(input);
        }
    }
    
    std::cout << "感谢使用RPN计算器！" << std::endl;
    return 0;
}
