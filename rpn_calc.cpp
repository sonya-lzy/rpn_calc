#include <iostream>
#include <stack>
#include <sstream>
#include <stdexcept>
#include <cctype>
#include <string>

class RPNCalculator {
private:
    std::stack<double> stack;

    bool isOperator(const std::string& token) {
        return token == "+" || token == "-" || token == "*" || token == "/";
    }

    double applyOperator(const std::string& op, double a, double b) {
        if (op == "+") return a + b;
        if (op == "-") return a - b;
        if (op == "*") return a * b;
        if (op == "/") {
            if (b == 0) throw std::runtime_error("Division by zero");
            return a / b;
        }
        throw std::runtime_error("Invalid operator");
    }

public:
    double calculate(const std::string& expression) {
        std::istringstream iss(expression);
        std::string token;

        while (iss >> token) {
            if (isOperator(token)) {
                if (stack.size() < 2) {
                    throw std::runtime_error("Insufficient operands for operator");
                }
                double b = stack.top(); stack.pop();
                double a = stack.top(); stack.pop();
                double result = applyOperator(token, a, b);
                stack.push(result);
            } else {
                try {
                    size_t pos;
                    double value = std::stod(token, &pos);
                    if (pos != token.size()) {
                        throw std::runtime_error("Invalid number format");
                    }
                    stack.push(value);
                } catch (const std::exception& e) {
                    throw std::runtime_error("Invalid token: " + token);
                }
            }
        }

        if (stack.size() != 1) {
            throw std::runtime_error("Expression did not reduce to a single value");
        }

        double result = stack.top();
        stack.pop();
        return result;
    }
};

int main() {
    RPNCalculator calculator;
    std::string expression;

    std::cout << "Enter RPN expression (e.g., 5 1 2 + 4 * + 3 -): ";
    if (std::getline(std::cin, expression)) {
        try {
            double result = calculator.calculate(expression);
            std::cout << "Result: " << result << std::endl;
        } catch (const std::exception& e) {
            std::cerr << "Error: " << e.what() << std::endl;
        }
    }

    return 0;
}
