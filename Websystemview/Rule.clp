;;;======================================================
;;;   Logistics Mode Expert System
;;;
;;;     This expert system help to decide which transportation mode to use under certain rule.
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************

; Rule 1
(defrule determine-budget-1 ""
    (not (low-budget ?))
=>
    (assert (low-budget (yes-or-no-p "does your budget below Rp 10,000,000 (yes/no)?"))))

; Rule 2
(defrule determine-budget-2 ""
    (not (medium-budget ?))
=>
    (assert (medium-budget (yes-or-no-p "does your budget between Rp 10,000,000 and Rp 50,000,000 (yes/no)?"))))

; Rule 3
(defrule determine-budget-3 ""
    (not (high-budget ?))
=>
    (assert (high-budget (yes-or-no-p "does your budget above Rp 50,000,000 (yes/no)?"))))

; Rule 4
(defrule determine-package-dimension-1 ""
    (not (container-package ?))
=> 
    (assert(container-package (yes-or-no-p "does your package dimension between 19 to 43 m3 (yes/no)?"))))

; Rule 5
(defrule determine-package-dimension-2 ""
    (not (pallet-package ?))
=>
    (assert(pallet-package (yes-or-no-p "does your package dimension less than 19 m3 (yes/no)?"))))

; Rule 6
(defrule determine-package-dimension-3 ""
    (not (special-package ?))
=>
    (assert( special-package (yes-or-no-p "does your package dimension more than 43 m3 (yes/no)?"))))

; Rule 7
(defrule determine-package-time-sensitive ""
    (not (special-handling ?))
=>
    (assert (special-handling (yes-or-no-p "does your package deteriorating through time (yes/no)?"))))

; Rule 8
(defrule determine-package-not-sensitive ""
    (not (normal-handling ?))
=>
    (assert (normal-handling (yes-or-no-p "does your package not deteriorating through time (yes/no)?"))))

; Rule 9
(defrule determine-destination-with-air ""
    (not (trans-is-air ?))
=>
    (assert (trans-is-air (yes-or-no-p "does your package is going through air (yes/no)?"))))

; Rule 10
(defrule determine-destination-with-water ""
    (not (trans-is-water ?))
=>
    (assert (trans-is-water (yes-or-no-p "does your package is going through water (yes/no)?"))))

; Rule 11
(defrule determine-destination-inter-island ""
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (trans-inter-island ?))
=>
    (assert (trans-inter-island yes)))

; Rule 10
(defrule determine-destination-within-island ""
    (not (trans-is-land ? ))
=>
    (assert (trans-is-land (yes-or-no-p "does your package is going through within island (yes/no)?"))))

;;;**********************
;;;* MODAL CHOICE RULES *
;;;**********************

; Rule 11
(defrule standard-cargo-train-conclusion ""
    (low-budget yes)
    (pallet-package yes)
    (normal-handling yes)
    (trans-is-land yes)
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "Use standard cargo train (logistics partner)" )))

; Rule 12
(defrule express-cargo-train-conclusion ""
    (or (high-budget yes) (medium-budget yes))
    (pallet-package yes)
    (normal-handling yes)
    (trans-is-land yes)
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "Use express cargo train" )))

; Rule 13
(defrule container-truck-conclusion ""
    (low-budget yes)
    (container-package yes)
    (normal-handling yes)
    (trans-is-land yes)
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "Use container truck" )))

; Rule 14
(defrule dedicated-container-truck ""
    (medium-budget yes)
    (container-package yes)
    (normal-handling yes)
    (trans-is-land yes)
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "Use dedicated container truck" )))

; Rule 15
(defrule specialized-train-truck ""
    (high-budget yes)
    (special-package yes)
    (normal-handling yes)
    (trans-is-land yes)
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "Use dedicated specialized train-truck" )))

; Rule 16
(defrule is-it-bulk ""
    (low-budget yes)
    (or (pallet-package yes)
    (container-package yes))
    (normal-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use bulk-shipping")))

; Rule 17
(defrule is-it-regular
    (medium-budget yes)
    (pallet-package yes)
    (normal-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use regular-shipping")))

; Rule 18
(defrule is-it-refigerator-container
    (medium-budget yes)
    (container-package yes)
    (special-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use refrigerator-container-shipping")))

; Rule 19
(defrule is-it-cargo-container
    (medium-budget yes)
    (container-package yes)
    (normal-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use cargo-container-shipping")))

; Rule 20
(defrule is-it-big-aero-cargo
    (high-budget yes)
    (container-package yes)
    (normal-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use big-aero-cargo")))

; Rule 21
(defrule is-it-regular-aero-cargo
    (high-budget yes)
    (pallet-package yes)
    (normal-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use regular-aero-cargo")))

; Rule 22
(defrule is-it-refrigerated-aero-cargo
    (high-budget yes)
    (container-package yes)
    (special-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use refrigerated-aero-cargo")))


; Rule 23
(defrule is-it-big-hull
    (high-budget yes)
    (special-package yes)
    (special-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use big-hull-shipping")))

; Rule 24
(defrule is-it-split-trucking
    (low-budget yes)
    (special-package yes)
    (normal-handling yes)
    (trans-is-land yes)
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use split-trucking")))

; Rule 25
(defrule is-it-partial-split
    (low-budget yes)
    (special-package yes)
    (normal-handling yes)
    (or (trans-is-water yes)
    (trans-is-air yes))
    (not (transportation-mode ?))
=>
    (assert (transportation-mode "use partial-split")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Logistics Mode Expert System")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (transportation-mode ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Transportation Mode:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))
