#lang racket
(require "lib.rkt"
         2htdp/batch-io
         rackunit)

(check-equal? (length (stop-words)) 429)

;;;

(define R-MOBY-WORDS
  (file->lines "r-words.txt"))

(check-equal? (length MOBY-WORDS) (length R-MOBY-WORDS))

(display-lines-to-file MOBY-WORDS "racket-words.txt" #:exists 'replace)

;;;

(check-equal? (count-frequency '()) '#hash())
(check-equal? (count-frequency '("a" "a" "t")) '#hash(("a" . 2) ("t" . 1)))

;;;

(define R-WORD-FREQ
  (let* ([raw-data (rest (read-csv-file "word-frequency.csv"))]
         [->string-and-number (lambda (lst)
                                (list (first lst) (string->number (second lst))))])
    (map ->string-and-number raw-data)))

(check-true (set=? RACKET-WORD-FREQ R-WORD-FREQ))