
class MacAddressNotFound < Sinatra::NotFound
  def name
    "Macaddress not found"
  end
end

class IncorrectMacAddress < Exception
  def name
    "Macaddress looks incorrect"
  end
end

class Node
  def self.load_from_macaddress(macaddress_source)
    macaddress = Node.macaddress_parse(macaddress_source,'\\:')

    q = Chef::Search::Query.new
    results = q.search('node', 'macaddress:'+macaddress)

    if results.last != 1
      raise MacAddressNotFound
    end

    # Load node from request
    node = results.first.first

    node
  end

  def self.macaddress_parse(macaddress_source, separator=':')
    macaddress = macaddress_source.gsub /[^a-f0-9]/, ''
    if macaddress.length != 12
      raise IncorrectMacAddress, "Macaddress incorrect"
    end

    macaddress.scan(/../).join(separator)
  end
end
