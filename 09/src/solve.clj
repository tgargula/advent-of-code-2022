(ns solve
  (:gen-class))

(require '[clojure.java.io :refer [reader]])
(require '[clojure.string :as str])

(defn get-difference [head tail]
  {:x (- (:x head) (:x tail)) :y (- (:y head) (:y tail))})

(defn adjust-line [line]
  (let [[head next & tail] line
        dx (:x (get-difference head next))
        dy (:y (get-difference head next))]
    (cond
      (or (and (>= dx 1) (> dy 1)) (and (> dx 1) (>= dy 1))) (let [new-next {:x (+ (:x next) 1) :y (+ (:y next) 1)}]
                                                               (cons head (adjust-line [new-next tail])))
      (or (and (>= dx 1) (< dy -1)) (and (> dx 1) (<= dy -1))) (let [new-next {:x (+ (get tail :x) 1) :y (- (get tail :y) 1)}]
                                                                 (cons head (adjust-line [new-next tail])))
      (or (and (<= dx -1) (> dy 1)) (and (< dx -1) (>= dy 1))) (let [new-next {:x (- (get tail :x) 1) :y (+ (get tail :y) 1)}]
                                                                 (cons head (adjust-line [new-next tail])))
      (or (and (<= dx -1) (< dy -1)) (and (< dx -1) (<= dy -1))) (let [new-next {:x (- (get tail :x) 1) :y (- (get tail :y) 1)}]
                                                                   (cons head (adjust-line [new-next tail])))
      (> dx 1) (let [new-next {:x (+ (get tail :x) 1) :y (get tail :y)}]
                 (cons head (adjust-line [new-next tail])))
      (> dy 1) (let [new-next {:x (get tail :x) :y (+ (get tail :y) 1)}]
                 (cons head (adjust-line [new-next tail])))
      (< dx -1) (let [new-next {:x (- (get tail :x) 1) :y (get tail :y)}]
                  (cons head (adjust-line [new-next tail])))
      (< dy -1) (let [new-next {:x (get tail :x) :y (- (get tail :y) 1)}]
                  (cons head (adjust-line [new-next tail])))
      :else line)))

(defn move-bridge [s head tail move steps]
  (let [dx (:x (get-difference head tail))
        dy (:y (get-difference head tail))]
    (cond
      (or (and (>= dx 1) (> dy 1)) (and (> dx 1) (>= dy 1))) (let [new-tail {:x (+ (get tail :x) 1) :y (+ (get tail :y) 1)}]
                                                               (move-bridge (conj s new-tail) head new-tail move steps))
      (or (and (>= dx 1) (< dy -1)) (and (> dx 1) (<= dy -1))) (let [new-tail {:x (+ (get tail :x) 1) :y (- (get tail :y) 1)}]
                                                                 (move-bridge (conj s new-tail) head new-tail move steps))
      (or (and (<= dx -1) (> dy 1)) (and (< dx -1) (>= dy 1))) (let [new-tail {:x (- (get tail :x) 1) :y (+ (get tail :y) 1)}]
                                                                 (move-bridge (conj s new-tail) head new-tail move steps))
      (or (and (<= dx -1) (< dy -1)) (and (< dx -1) (<= dy -1))) (let [new-tail {:x (- (get tail :x) 1) :y (- (get tail :y) 1)}]
                                                                   (move-bridge (conj s new-tail) head new-tail move steps))
      (> dx 1) (let [new-tail {:x (+ (get tail :x) 1) :y (get tail :y)}]
                 (move-bridge (conj s new-tail) head new-tail move steps))
      (> dy 1) (let [new-tail {:x (get tail :x) :y (+ (get tail :y) 1)}]
                 (move-bridge (conj s new-tail) head new-tail move steps))
      (< dx -1) (let [new-tail {:x (- (get tail :x) 1) :y (get tail :y)}]
                  (move-bridge (conj s new-tail) head new-tail move steps))
      (< dy -1) (let [new-tail {:x (get tail :x) :y (- (get tail :y) 1)}]
                  (move-bridge (conj s new-tail) head new-tail move steps))
      (= steps 0) [s head tail]
      :else (case move
              "R" (let [new-head {:x (+ (get head :x) 1) :y (get head :y)}]
                    (move-bridge s new-head tail move (- steps 1)))
              "L" (let [new-head {:x (- (get head :x) 1) :y (get head :y)}]
                    (move-bridge s new-head tail move (- steps 1)))
              "U" (let [new-head {:x (get head :x) :y (+ (get head :y) 1)}]
                    (move-bridge s new-head tail move (- steps 1)))
              "D" (let [new-head {:x (get head :x) :y (- (get head :y) 1)}]
                    (move-bridge s new-head tail move (- steps 1)))
              :error))))

(defn apply-moves [sets heads tails moves]
  (cond
    (or (nil? moves) (empty? moves)) (last sets)
    :else (let [[[move steps] & rest] moves
                steps (Integer/parseInt steps)
                [s head tail] (move-bridge (last sets) (last heads) (last tails) move steps)]
            (apply-moves (conj sets s) (conj heads head) (conj tails tail) rest))))

(defn main []
  (let [head {:x 0 :y 0}
        tail {:x 0 :y 0}
        s (set [tail])]
    (with-open [rdr (reader "./data/input.txt")]
      (let [moves (reduce conj [] (map (fn [line] (str/split line #" ")) (line-seq rdr)))]
        (println (count (apply-moves [s] [head] [tail] moves)))))))

(main)