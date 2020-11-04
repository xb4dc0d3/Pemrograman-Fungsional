# Lambda Calculus Interpreter (in Haskell)
Lambda Calculus Interpter adalah sebuah program untuk interpretasi dari suatu representasi input **Lambda Calculus**. Lambda Calculus sendiri adalah suatu sistem formal dalam logika matematika berupa komputasi ekspresi berdasarkan suatu fungsi Abstraksi dan Aplikasi dengan menggunakan *binding* Variabel. Lambda Calculus juga merupakan model komputasi universal yang bisa disimulasikan pada Turing Machine. Lambda Calculus diperkenalkan oleh matematikawan **Alonzo Church** sekitar tahun 1930.

Lambda Calculus Interpreter ini dibangun menggunakan bahasa pemrograman Haskell, bentuk dari Lambda Calculus dilakukan normalisasi atau Konversi dengan memanfaatkan *rule* atau *term* pada Lambda Calculus, meliputi `Alpha Conversion`, `Beta Reduction`, dan `Eta Expansion` (tidak digunakan pada interpreter). Interpreter ini dapat merepresentasikan kedalam bentuk
- Bilangan cacah (positif) dari `0 sampai 9`
- Operator `"+"` (penjumlahan)
- Operator `"*"` (perkalian)

## Prasyarat
Pastikan `GHC` sudah terinstall pada komputer, jika belum bisa mengunjungi *link* berikut.

Linux
```
https://www.haskell.org/downloads/linux/
```

Windows
```
https://www.haskell.org/platform/windows.html
```

Check version of `GHC`
```
$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 8.0.2
```

## Set Up
Pada proses Set Up terdapat dua proses, `kompilasi` dan `eksekusi`. Terdapat dua file yang ada di dalam repo `lci.hs` dan `lci-numeral.hs`, kedua file tersebut berada pada folder `src/church-numerals-untyped`.

### Compile (Kompilasi)
    ```
    $ ghc lci.hs -o lci                  //file pertama
    $ ghc lci-numeral.hs -o lci-numeral  //file kedua
    ```
### Execute (Eksekusi)
    ```
    $ ./lci                   //file pertama
    $ ./lci-numeral           //file kedua
    ```

## Aturan Penggunaan
Dalam Lambda Calculus Interpreter ini, ada beberapa aturan yang perlu diperhatikan dalam memasukkan `input` ketika menjalankan file. Berikut adalah aturan yang ada pada interpreter.

- Input harus diletakan di dalam tanda kutip `" "`
- Input tidak memakai whitespace atau spasi
- Input angka (0-9) inclusive atau (0 <= angka <= 9)
- Input hanya memiliki operator `+` dan `*`
- Haskell tidak support encoding Lambda sehingga untuk input menggunakan dua backslash `\\x` atau bisa dibaca sebagai `lambda x`
- Tanda `()` perlu diperhatikan agar tidak terjadi kesalahan

Untuk penjelasan lebih lanjut akan didemonstrasikan pada bagian `Demo`.

## Contoh input pada Terminal/CLI
#### Lambda Calculus
- `"(\\x.\\y.x)"`
- `"(\\x.(\\y.x))z`
- `"((\\s.\\z.s(s(z)))(\\w.\\y.\\x.y(wyx))(\\u.\\v.u(u(u(v)))))"` (penjumlahan 2+3 dalam lambda calculus)
#### Numeral (dalam String)
- `"5"`
- `"9"`
#### Operator Penjumlahan (`+`)
- `"5+9"`
#### Operator Perkalian (`*`)
- `"2*3"`

## Modifikasi
Sebelumnya pada hasil `fork` dari repo yang digunakan, sudah terdapat mekanisme parser yang menerima input lambda. Input tersebut dapat diolah sedemikian rupa sehingga dapat melewati proses `alpha conversion` dan `beta reduction` dann nantinya akan didapatkan bentuk representasi lambda calculus paling sederhana.

Modifikasi yang dilakukan adalah dengan membuat fungsi baru agar dapat menerima input angka, operator `+`, dan operator `*`, sedangkat untuk fungsi output dibuat suatu mekanisme agar dapat merepresentasikan kembali bentuk-bentuk dari numeral dan operator menjadi lamba calculus seperti semula.

- Bentuk awal Term (tidak dimofidikasi)
    ```
    data Term = Var String
              | Application Term Term
              | Abstraction String Term
              deriving(Show, Eq)
    ```

- Membuat parser untuk mengembalikan bentuk lambda (Term) ke Maybe Integer
    ```
    term_to_integer :: Term -> Maybe Integer
    term_to_integer (Abstraction s (Abstraction z apps)) = go apps
        where
            go (Var x) | x == z = Just 0
            go (Application (Var f) e) | f == s = (+ 1) <$> go e
            go _ = Nothing
    term_to_integer _ = Nothing
    ```

- Perubahan minor pada file `lci.hs`
    ```
    --- Melakukan cek apabila tidak ada representasi lambda sebagai angka, akan mengeluarkan -1 ---
    flagNumeral :: String -> Integer
    flagNumeral bb = fromMaybe (-1) (string_to_term (myparse bb))
    
    --- Print status representasi lambda pada bilangan ---
    numeral :: Integer -> String
    numeral yy 
        | yy == -1 = "Not church representation"
        | otherwise = show yy
    ```

- Perubahan minor pada file `lci-numeral.hs`
    ```
    --- Konversi dari bentuk string numeral ke Lambda numeral ---
    numeral_to_lambda :: Integer -> String -> Integer -> String
    numeral_to_lambda num1 op num2
        | op == "+" = (prettyprint (chPlus (church num1) (church num2)))
        | op == "*" = (prettyprint (chMult (church num1) (church num2)))
        | otherwise = "Something's wrong"
    ```

## Demo
- File `lci.hs`
    ```
    $ rlwrap ./lci
    Type a lambda expression like "(\\x.\\y.x)" or ^D to exit:
    "((\\s.\\z.s(s(z)))(\\w.\\y.\\x.y(wyx))(\\u.\\v.u(u(u(v)))))"
    > Normal form of ((\s.\z.s(s(z)))(\w.\y.\x.y(wyx))(\u.\v.u(u(u(v))))): 
    ==> Lambda church notation: "\\b.\\c.b(b(b(b(bc))))"
    ==> Numeral notation: 5
    
    "((\\s.\\z.s(s(z)))(\\w.\\y.\\x.y(wyx))(\\u.\\v.u(u(u(v)))))zzzzzzz"
    > Normal form of ((\s.\z.s(s(z)))(\w.\y.\x.y(wyx))(\u.\v.u(u(u(v)))))zzzzzzz: 
    ==> Lambda church notation: "z(z(z(z(zz)))zz)zzzzz"
    ==> Numeral notation: Not church representation
    
    "(\\x.\\y.x(x(y)))"
    > Normal form of (\x.\y.x(x(y))): 
    ==> Lambda church notation: "\\x.\\y.x(xy)"
    ==> Numeral notation: 2
    
    "(\\x.\\y.x)"
    > Normal form of (\x.\y.x): 
    ==> Lambda church notation: "\\x.\\y.x"
    ==> Numeral notation: Not church representation
    
    "((\\s.\\z.s(z)))(\\w.\\y.\\x.y(wyx))(\\u.\\v.u(u(u(v)))))"
    > Normal form of ((\s.\z.s(z)))(\w.\y.\x.y(wyx))(\u.\v.u(u(u(v))))): 
    ==> Lambda church notation: "\\b.\\c.b(b(b(bc)))"
    ==> Numeral notation: 4
    ```

- File `lci-numeral.hs`
  ```
  $ rlwrap ./lci-numeral
  Type a numeral expression like "1", "1+2", "2*4", or ^D to exit:
    "1"
    > Normal form of 1: 
    ==> Lambda church notation: \f.\x.fx
    ==> Numeral notation: 1
    
    "1+2"
    > Normal form of 1+2: 
    ==> Lambda church notation: \f.\x.f(f(fx))
    ==> Numeral notation: 3
    
    "1*9"
    > Normal form of 1*9: 
    ==> Lambda church notation: \f.\x.f(f(f(f(f(f(f(f(fx))))))))
    ==> Numeral notation: 9
    
    "2*5"
    > Normal form of 2*5: 
    ==> Lambda church notation: \f.\b.f(f(f(f(f(f(f(f(f(fb)))))))))
    ==> Numeral notation: 10
    
    "6"
    > Normal form of 6: 
    ==> Lambda church notation: \f.\x.f(f(f(f(f(fx)))))
    ==> Numeral notation: 6
    ```

## Kreator
* **Jimouris** - [Github](https://github.com/jimouris)

## Diubah oleh
* **Muhammad Ardivan Satrio Nugroho** - 1706025371 - [Gitlab](https://gitlab.cs.ui.ac.id/muhammad.ardivan/)

## Inspirasi
- Sumber
  https://github.com/jimouris/lambda-calculus-interpreter
- Konversi Notasi Church ke Numeral
  https://stackoverflow.com/questions/58687538/converting-from-church-encoding-to-numerals