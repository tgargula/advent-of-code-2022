(ns solve
  (:gen-class))

(require '[clojure.java.io :refer [reader]])
(require '[clojure.string :as str])

(defn get-difference [head tail]
  {:x (- (:x head) (:x tail)) :y (- (:y head) (:y tail))})

(defn adjust-line [line]
  (let [[head next & tail] line]
    (case (nil? next)
      true line
      (let [{dx :x dy :y} (get-difference head next)
            adjust (fn [new-next] (cons head (adjust-line (cons new-next tail))))]
        (cond
          (or (and (>= dx 1) (> dy 1)) (and (> dx 1) (>= dy 1))) (adjust {:x (+ (:x next) 1) :y (+ (:y next) 1)})
          (or (and (>= dx 1) (< dy -1)) (and (> dx 1) (<= dy -1))) (adjust {:x (+ (:x next) 1) :y (- (:y next) 1)})
          (or (and (<= dx -1) (> dy 1)) (and (< dx -1) (>= dy 1))) (adjust {:x (- (:x next) 1) :y (+ (:y next) 1)})
          (or (and (<= dx -1) (< dy -1)) (and (< dx -1) (<= dy -1))) (adjust {:x (- (:x next) 1) :y (- (:y next) 1)})
          (> dx 1) (adjust {:x (+ (:x next) 1) :y (:y next)})
          (> dy 1) (adjust {:x (:x next) :y (+ (:y next) 1)})
          (< dx -1) (adjust {:x (- (:x next) 1) :y (:y next)})
          (< dy -1) (adjust {:x (:x next) :y (- (:y next) 1)})
          :else line)))))

(defn move-bridge [s line move steps]
  (let [new-line (adjust-line line)
        [head & tail] new-line
        new-s (conj s (last new-line))
        move-head (fn [new-head] (move-bridge new-s (cons new-head tail) move (- steps 1)))]
    (case steps
      0 [new-s new-line]
      (case move
        "R" (move-head {:x (+ (:x head) 1) :y (:y head)})
        "L" (move-head {:x (- (:x head) 1) :y (:y head)})
        "U" (move-head {:x (:x head) :y (+ (:y head) 1)})
        "D" (move-head {:x (:x head) :y (- (:y head) 1)})
        :error))))

(defn apply-moves [sets lines moves]
  (case (nil? moves)
    true (last sets)
    (let [[[move steps] & rest] moves
          steps (Integer/parseInt steps)
          [s new-line] (move-bridge (last sets) (last lines) move steps)]
      (apply-moves (conj sets s) (conj lines new-line) rest))))

(defn main []
  (let [step 2
        line-length (case step 1 2 2 10 :error)
        line (repeat line-length {:x 0 :y 0})
        s (set [{:x 0 :y 0}])]
    (with-open [rdr (reader "./data/input.txt")]
      (let [moves (reduce conj [] (map (fn [fileline] (str/split fileline #" ")) (line-seq rdr)))]
        (println (count (apply-moves [s] [line] moves)))))))

(main)