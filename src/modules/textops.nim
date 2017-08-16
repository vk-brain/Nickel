include base
import unicode, sequtils, future

const
  # Таблица для переворачивания символов
  FlipTable = {"a": "ɐ","b": "q", "c": "ɔ","d": "p", 
    "e": "ǝ","f": "ɟ", "g": "ƃ", "h": "ɥ",
    "i": "ı", "j": "ɾ", "k": "ʞ", "m": "ɯ",
    "n": "u", "p": "d", "q": "ᕹ", "r": "ɹ",
    "t": "ʇ", "u": "n", "v": "ʌ", "w": "ʍ",
    "y": "ʎ", ".": "˙", "[": "]", "(": ")",
    "]": "[", ")": "(", "{": "}", "}": "{",
    "?": "¿", "!": "¡", "\"": ",", ",": "'",
    "<": ">", "_": "‾", "‿": "⁀", "⁅": "⁆",
    "∴": "∵", "\r": "\n", "а": "ɐ", "б": "ƍ",
    "в": "ʚ", "г": "ɹ", "д": "ɓ", "ё": "ǝ",
    "е": "ǝ", "ж": "ж", "з": "ε", "и": "и",
    "й": "ņ", "к": "ʞ", "л": "v", "м": "w",
    "н": "н", "о": "о", "п": "u", "р": "d", 
    "с": "ɔ","т": "ɯ", "у": "ʎ", "ф": "ȸ", 
    "х": "х", "ц": "ǹ", "ч": "Һ", "ш": "m", 
    "щ": "m", "ъ": "q", "ы": "ıq", "ь": "q",
    "э": "є", "ю": "oı", "я": "ʁ", "1": "Ɩ",
    "2": "ᄅ", "3": "Ɛ", "4": "ㄣ", "5": "ϛ",
    "6": "9", "7": "ㄥ", "8": "8", "9": "6", "0": "0"}.toTable()
  
  InvertedFlipTable = lc[
    (FlipTable[key], key) | (key <- FlipTable.keys), tuple[a, b: string]
  ].toTable()

module "&#128394;", "Операции с текстом":
  command "перечеркни", "зачеркни":
    usage = "зачеркни <строка> - перечеркнуть строку"
    if text == "":
      answer "перечеркни <строка> - перечеркнуть строку"
    else:
      var res = ""
      # Проходимся по UTF8 символам в тексте
      for x in text.utf8:
        # Добавляем к результату символ + доп. коды (для зачёркивания)
        res.add x & "&#38;#0822;"
      answer res
  
  command "переверни":
    usage = "переверни <строка> - перевернуть строку"
    var data = ""
    # Переводим строку в нижний регистр и проходимся по UTF8 символам
    for letter in unicode.toLower(text.reversed).utf8:
      # Если ключ есть в нашей таблице
      if letter in FlipTable: 
        data &= FlipTable.getOrDefault(letter)
      # Если перевёрнутая буква есть в инвертированной таблице
      elif InvertedFlipTable.hasKey(letter):
        data &= InvertedFlipTable[letter]
      # Иначе просто добавляем саму букву
      else:
        data &= letter
    answer data
    
  command "лол":
    usage = "лол <кол-во> - генерирует смех определённой длины из символов АЗХ"
    const LolWord = "АЗХ"
    try:
      answer LolWord.repeat(args[0].parseInt.clamp(5, 90))
    except:
      answer usage