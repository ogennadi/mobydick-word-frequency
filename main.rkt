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


;; Wishlist:
;; MOBY_WORDS
;; (bagify lst)  (https://stackoverflow.com/questions/5740307/count-occurrence-of-element-in-a-list-in-scheme#5740464)
;; (remv* v-lst lst)
;; (bagify (remv* STOP-WORDS MOBY-WORDS))

