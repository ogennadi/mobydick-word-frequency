#lang racket
(require 2htdp/batch-io
         rackunit)



(define STOP-WORDS
  (let ([not-stop-word? (lambda (x) (or (equal? x "") (string-prefix? x "#")))])
    (filter-not  not-stop-word? (file->lines "stop-words.txt"))))
(check-equal? (length STOP-WORDS) 429)

;;;

(define (expand-number-acronym str)
  (if (string-prefix? str "1.")
      (string-split str ".")
      str))

(define MOBY-WORDS
  (let* ([rough-tokens (string-split (file->string "mobydick.txt") #px"[-\uFEFF/:\\@“”!?;—\\s\\$\\*\\(\\)]+")]
         [trim  (lambda (str)  (string-trim str #px"[\\[‘’:&%.,\\]\\(\\)\\s]+"))]
         [lowercase-trimmed (map (compose string-downcase trim) rough-tokens)]
         [smooth-tokens (flatten (map expand-number-acronym lowercase-trimmed))])
    (remove* '("#2701" "") smooth-tokens)))
(define R-MOBY-WORDS
  (file->lines "r-words.txt"))

(check-equal? (length MOBY-WORDS) (length R-MOBY-WORDS))

(display-lines-to-file MOBY-WORDS "racket-words.txt" #:exists 'replace)

;;;

(define (count-frequency lst)
  (foldl (lambda (key ht)
           (hash-update ht key add1 0))
         #hash() lst))
(check-equal? (count-frequency '()) '#hash())
(check-equal? (count-frequency '("a" "a" "t")) '#hash(("a" . 2) ("t" . 1)))

;;;

(define R-WORD-FREQ
  (let* ([raw-data (rest (read-csv-file "word-frequency.csv"))]
         [->string-and-number (lambda (lst)
                                (list (first lst) (string->number (second lst))))])
    (map ->string-and-number raw-data)))

(define RACKET-WORD-FREQ
  (let* ([freq-hash   (count-frequency (remove* STOP-WORDS MOBY-WORDS))]
         [freq-list   (hash-map freq-hash list)]
         [sorted-list (sort freq-list > #:key last)])
    (take sorted-list 100)))

(check-true (set=? RACKET-WORD-FREQ R-WORD-FREQ))