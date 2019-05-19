#lang racket
(provide RACKET-WORD-FREQ stop-words MOBY-WORDS count-frequency)

(define (stop-words)
  (let ([not-stop-word? (lambda (x) (or (equal? x "") (string-prefix? x "#")))])
    (filter-not  not-stop-word? (file->lines "stop-words.txt"))))

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

;; https://stackoverflow.com/a/5741004/2042190
(define (count-frequency lst)
  (foldl (lambda (key ht)
           (hash-update ht key add1 0))
         #hash() lst))

(define RACKET-WORD-FREQ
  (let* ([freq-hash   (count-frequency (remove* (stop-words) MOBY-WORDS))]
         [freq-list   (hash-map freq-hash list)]
         [sorted-list (sort freq-list > #:key last)])
    (take sorted-list 100)))