# rpn_manual.nim
import nimib, nimibook, strformat, os

nbInit(theme = useNimibook)            # 关键：启用 book 主题
nbAddCss("body { font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans',sans-serif; }")

# --------------------------------------------------
nbChapter: "RPN 计算器使用手册"
nbText: "基于 C++17 实现的命令行逆波兰计算器，可执行文件 `rpn_calc`，本手册即其完整说明。"

# --------------------------------------------------
nbChapter: "1. 安装与编译"
nbCode:
  ## 克隆仓库
  git clone https://github.com/yourname/yourrepo.git
  cd yourrepo

  ## 编译（Linux/macOS/WSL）
  g++ rpn_calc.cpp -std=c++17 -o rpn_calc

  ## Windows (MinGW)
  g++ rpn_calc.cpp -std=c++17 -o rpn_calc.exe
nbText: "编译成功后，当前目录会出现可执行文件 `rpn_calc`（或 `rpn_calc.exe`）。"

# --------------------------------------------------
nbChapter: "2. 快速体验"
nbCode:
  ./rpn_calc
  > 5 5 + 3 *
  结果: 30
  > help
  > q
nbText: "启动即进入交互模式，提示符为 `>`，输入 `q` 或 `quit` 退出。"

# --------------------------------------------------
nbChapter: "3. 操作符一览"
nbTable:
  | 类别 | 符号 / 命令 | 栈变化 | 描述 |
  |---|---|---|---|
  | 四则 | `+` | a b → (a+b) | 加法 |
  |  | `-` | a b → (a-b) | 减法 |
  |  | `*` | a b → (a×b) | 乘法 |
  |  | `/` | a b → (a÷b) | 除法（除零报错） |
  | 数学 | `sqrt` | a → √a | 平方根（负数报错） |
  |  | `pow` | a b → a^b | 幂运算 |
  |  | `sin` | a → sin(a°) | 正弦（角度） |
  |  | `cos` | a → cos(a°) | 余弦（角度） |
  | 特殊 | `fib` | n → F(n) | 斐波那契（n 需非负整数） |
  | 栈控 | `clear` | 清空整个栈 |  |
  |  | `display` | 打印当前栈 |  |
  | 系统 | `help` | 显示帮助 |  |
  |  | `history` | 列出计算历史 |  |
  |  | `q` / `quit` | 退出程序 |  |

# --------------------------------------------------
nbChapter: "4. 错误代码"
nbText: "所有错误均带统一前缀 **“错误:”**，便于脚本捕获。"
nbList:
  - 栈为空 —— 栈内无元素却尝试 `pop`
  - 栈元素不足 —— 二元运算至少需要 2 个操作数
  - 除零错误 —— `/` 右操作数为 0
  - 负数不能开平方根 —— `sqrt` 参数 < 0
  - 斐波那契数列需要非负整数 —— `fib` 参数非整数或负数
  - 未知操作符 —— 输入了未定义的符号

# --------------------------------------------------
nbChapter: "5. 综合示例"
nbCode:
  ## 三角函数组合
  > 30 sin 60 cos *
  结果: 0.433013

  ## 斐波那契
  > 10 fib
  结果: 55

  ## 连续表达式
  > 1 2 + 3 + 7 7 * +
  结果: 55

  ## 查看历史
  > history
  1. 5 5 + 3 * = 30
  2. 10 fib = 55
nbText: "任何时候都可 `display` 查看栈内剩余值，`clear` 一键清空。"

# --------------------------------------------------
nbChapter: "6. 批量模式（重定向）"
nbCode:
  ## 把表达式写进文件
  echo "3 4 + 2 * 5 /" > expr.txt
  ./rpn_calc < expr.txt
  ## 输出：结果: 2.8
nbText: "适合在 Shell 脚本或 CI 中做自动化计算。"

# --------------------------------------------------
nbChapter: "7. 如何生成本手册"
nbCode:
  ## 安装依赖（仅需一次）
  nimble install nimib@#head nimib-book

  ## 编译文档
  nim r rpn_manual.nim
  ## 产出：rpn_manual.html（自带左侧目录、搜索、深色模式）
nbText: "生成的单文件 `rpn_manual.html` 可直接放到 GitHub Pages 或其他静态托管服务。"

# --------------------------------------------------
nbChapter: "8. 源代码地址"
nbList:
  https://github.com/sonya-lzy/zyy/rpn_manual.html
# --------------------------------------------------
nbSave  
