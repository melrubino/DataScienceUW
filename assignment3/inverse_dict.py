import MapReduce
import sys

"""
Word Count Example in the Simple Python MapReduce Framework
"""


mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(list):
    doc_id = list[0]
    text = list[1]
    words = text.split()
    word_dict = {}
    for w in words:
        word_dict[w] = 1
    for key in word_dict:    
        mr.emit_intermediate(key, doc_id)

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts

    mr.emit((key, list_of_values))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
