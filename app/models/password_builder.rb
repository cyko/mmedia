class PasswordBuilder

=begin
  Crea un string de longitud leng. El string puede contener aleatoriamente caracteres letras y números. 
  El prefijo self. indica que se trata de un método de clase. 
=end  
  def self.new_password(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end