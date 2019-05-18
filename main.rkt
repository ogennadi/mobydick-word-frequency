#lang racket
(require 2htdp/batch-io
         rackunit)

(define WORD-FREQ (rest (read-csv-file "word-frequency.csv")))

(define (calculate-word-freq)
  WORD-FREQ)
(check-equal? (calculate-word-freq) WORD-FREQ)

(define STOP-WORDS
  (let ([not-stop-word? (lambda (x) (or (equal? x "") (string-prefix? x "#")))])
    (filter-not  not-stop-word? (file->lines "stop-words.txt"))))
(check-equal? (length STOP-WORDS) 429)

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

;; Wishlist:
;; (bagify lst)  (https://stackoverflow.com/questions/5740307/count-occurrence-of-element-in-a-list-in-scheme#5740464)
;; (remv* v-lst lst)
;; (bagify (remv* STOP-WORDS MOBY-WORDS))

