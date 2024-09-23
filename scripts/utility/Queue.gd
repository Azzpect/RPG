class_name Queue


var structure = []

func enqueue(val):
    structure.append(val)


func dequeue():
    if(structure.size() > 0):
        return structure.pop_front()
    else:
        return null