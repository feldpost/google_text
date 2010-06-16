module GoogleText
  class Account
    attr_accessor :email, :password
    
    def initialize(email,password)
      @email, @password = email, password
    end
  end
end