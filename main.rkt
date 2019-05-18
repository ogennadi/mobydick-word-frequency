#lang racket
(require 2htdp/batch-io
         rackunit)

(define WORD-FREQ (rest (read-csv-file "word-frequency.csv")))

(define (calculate-word-freq)
  WORD-FREQ)

(check-equal? (calculate-word-freq) WORD-FREQ)