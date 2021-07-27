import unittest

from app import app

class TestCase(unittest.TestCase):
  def test_hello(self):
    expected = b'Hello, World!'
    tester   = app.test_client(self)
    response = tester.get('/')
    self.assertEqual(response.status_code, 200)
    self.assertEqual(response.data, expected)
    
if __name__ == '__main__':
  unittest.main()
