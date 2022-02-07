#lang racket

;; Reading input idea obtained from (https://docs.racket-lang.org/reference/Byte_and_String_Input.html)
(define (input-file)
  (printf "What is the name of the ballot file?~n")
  (read-line)
  )

(define (not-none? n)
  (not(equal? n "none")
      ))

;; Counter from class notes
(define (my-count pred? lst)
  (if (empty? lst) 0 (+ (if (pred? (first lst)) 1 0)
                        (my-count pred? (rest lst)))
      ))

(define (total-ballots input)
  (printf "~nTotal # of ballots: ~a~n~n"
          (length (map string->list input))
          ))

(define (empty-ballots input)
  (printf "~nempty: ~a~n"
          (my-count (curry equal? "none") input)
          ))

(define (full-ballots cand input)
  (printf "full: ~a~n"
          (my-count (curry equal? (length cand))
                    (map length input))
          ))

(define (count-ballot lst x)
  (my-count (curry equal? x) (flatten lst)
            ))

;; Creates pairs from two lists (from class notes)
(define (pairs lst1 lst2)
  (cond [(empty? lst1) '()]
        [(empty? lst2) '()]
        [else (cons (list (first lst1) (first lst2))
                    (pairs (rest lst1) (rest lst2)))]
        ))
  
(define (counted-ballots cand input)
  (cond [(empty? input) (printf "")]
        [else (pairs cand (map (curry count-ballot input)
                               cand))]
        ))

;; Pred to compare second element in two pairs
(define (pair-greater? a b)
  (if (> (second a) (second b)) #t #f)
  )

(define (sort-candidate cand)
  (sort cand pair-greater?)
  )

(define (print-ballots pr)
  (cond [(empty? pr) (printf "")]
        [(not(equal? (length (first pr)) 2))
         (print-ballots (rest pr))]
        [else (printf "~a: ~a~n" (first (first pr))
                      (second (first pr)))
              (print-ballots (rest pr))]
        ))

;; Main function
(define (main)
  (define my-file
    (input-file)
    )
  (define input-lines
    (file->lines my-file)
    )
  ;; Creates list of each line from input file
  (define lines
    (map remove-duplicates (map string-split input-lines)
         ))
  (define candidates
    (filter not-none? (remove-duplicates (flatten lines))
            ))
  (total-ballots input-lines)
  (print-ballots (sort-candidate
                  (counted-ballots candidates lines)
                  ))
  (empty-ballots input-lines)
  (full-ballots candidates lines) 
  )

;; Runs main function
(main)