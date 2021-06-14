# DTO class for animals.

class Animal():

  animal = 'Cat'
  sound  = 'Meow'
  count  = 1

  def to_dict(self):
    return {
      "animal": self.animal,
      "sound": self.sound,
      "count": self.count
    }

  def from_dict(self, data):
    for field in ['animal', 'sound', 'count']:
      if field in data:
        setattr(self, field, data[field])
