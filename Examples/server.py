from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
 
class IphoneChat(Protocol):
    def connectionMade(self):
        self.factory.clients.append(self)
        print "clients are ", self.factory.clients

    def connectionLost(self, reason):
        self.factory.clients.remove(self)

    def dataReceived(self, data):
        a = data.split(':')
        print a
        if len(a) > 1:
            command = a[0]
            content = a[1]
 
            msg = ""
            if command == "Iam":
                self.name = content
                msg = self.name + " has joined"
 
            elif command == "Msg":
                msg = self.name + ": " + content
                print msg
 
            for c in self.factory.clients:
                c.message(msg)

    def message(self, message):
        self.transport.write(message + '\n')
 
factory = Factory()
factory.clients = []
factory.protocol = IphoneChat
reactor.listenTCP(80, factory)
print "Iphone Chat server started"
reactor.run()
