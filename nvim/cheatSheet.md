# My Nvim Cheatsheet

## which-key combinations

- leader + un = dismiss all notif
- leader + cR = rename file
- leader + n = notif
- leader + uw = wrap
- leader + . = scratch buffer
- leader + S = scratch select buffer
- leader + ucc = toggle copilet
- leader + z = fold menu and flash search
  - za = toggle fold under cursor
  - zA = toggle all folds
  - z= = spelling suggestions
  - zk = flash search
  - zK = flash search wrap
- leader + uC = ColorScheme
- leader + mdn = markdown-preview start
- leader + mds = markdown-preview stop
- ctrl + Z = Split window maximize

- ctrl + / = terminal
- ctrl + t = better terminal
- `:term` for another terminal

## Nvim Commands

- `: set spell` se spelling check hogi and `s]`&`s[` se next and previous wrong word pe jump
  then `z=` se spellchecker open

- Disable Formatter for Current Session by `:lua vim.g.autoformat = false`

- `:!` likhte hi shell pe shift hojaenge and normal cmd perform kr skte like ls, touch, mkdir, etc

- `:%s/\v(fizz|buzz)/foo/gc` To replace both "fizz" and "buzz" with "foo" in one command and confirm each substitution
- `:%s/\v(fizz|buzz)/\=input("Replace with: ")/gc` To replace both "foo" and "bar" with user input in one command
- `:%s/\v(fizz|buzz)/\=["foo", "bar"][input("0 for foo, 1 for bar: ") + 1]/gc` ek baar firse try krke still dekhna hai coz kaam nahi kra tha
- `:CellularAutomaton <Tab>` for fun animations
- `:Tetris` to play tetris
- `g?` to encrypt in ROT13 (rotate by 13 places)
- `e <url>` to get that page's url into your buffer
- `r! < shell command>` to get the output of that command into your buffer

## Substitution regex cheatsheet

- `\v` → Enables "very magic" mode (makes regex simpler).
- `g` → Replace all occurrences in the line.
- `c` → Confirm each substitution.
- `(fizz|buzz)` → Matches either "foo" or "bar".
- `\=input("Replace with: ")` → Prompts you to enter the replacement manually each time.
- `(\=)` → is a Vimscript expression that evaluates the code inside it, meaning the replacement is evaluated dynamically
- `+ 1` → Since Vim lists start from index 1, we add 1 to match the correct index.
- `:<command or feature of nvim>`colon dalne ke baad jo bhi nvim ki command use krna chahte ho ya fir koi feature usko bs likh do aur help mil jaegi ya fir tab daba ke search kr lo ya fir FZF likh ke enter then search

## Random shit jo pata chli

- I used "! ls | tee <file-path>" and then it added added it to my file but it didn't changed the buffer or the saved file blki usi buffer me usne add krdiya and saved file hi thi still even tho file ka sara content change hogaya tha
