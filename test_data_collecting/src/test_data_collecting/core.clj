(ns test-data-collecting.core
  (:require [clj-http.client :as http]
            [muuntaja.core :as m]))

(def titles (->> (http/get "https://feuerx.net/api/posts/titles")
                :body
                (m/decode "application/json")))

(def ids (mapv :Id titles))

(def posts (->> ids
                (mapv (fn [id]
                        (future
                          (m/decode
                           "application/json"
                           (:body
                            (http/get (str "https://feuerx.net/api/posts/post/" id)))))))
                (mapv deref)))

(spit "/Users/feuer/Projects/New Murja Client/New Murja ClientTests/resources/titles.json"
      (slurp
       (m/encode "application/json" titles)))

(spit "/Users/feuer/Projects/New Murja Client/New Murja ClientTests/resources/posts.json"
      (slurp
       (m/encode "application/json" posts)))
 ;;titlet, tallenna tulos, iteroi id:t läpi, hae niiltä mitä feuerx.net sattuu palauttamaan ja tallenna ne johonkin mistä ne voi ladata swift-testeissä ....
