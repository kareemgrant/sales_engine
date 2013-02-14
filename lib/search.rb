module Search

  MERCHANT = %w{id name created_at updated_at}

  def self.find_by(klass, attribute, *args)
    puts "Class: #{klass}"
    puts "attribute: #{attribute}"
    puts "criteria: #{args.join(" ")}"
    criteria = args.join(" ")

    # get the @data array for that class @data = klass.all
    #attribute = attribute.to_sym
   # puts attribute.class
    data = klass.all
    #puts data.inspect

    array = data.select do |merchant|
      merchant.instance_variable_get("@#{attribute}") == criteria
    end

    puts ""
    puts "results: "
    puts array.inspect

    # validate that the passed in attribute is correct (search against a hash or array)
    # strip our the arg turn it into a string and search(must handle multiple words)
    # return the found records to klass

  end
end