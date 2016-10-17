class Customer
  attr_accessor :name, :lastname, :age, :code, :id

  def initialize(name:, lastname:, age:, code:, id:)
    @name = name
    @lastname = lastname
    @age = age
    @code = code
    @id = id
  end

  def full_name
    "#{name} #{lastname}"
  end

  def create
    $pg.exec_params(sql_insert, sql_insert_params)
  end

  def self.all(per_page = 10, page = 0)
    data_customers = $pg.exec("select * from customer order by id limit #{per_page}
                                offset #{per_page * page}")
    data_customers.map do |data|
      Customer.new(name: data['name'], lastname: data['lastname'],
                age: data['age'], code: data['code'], id: data['id'])
    end
  end

  def self.count 
    $pg.exec("select count(*) from customer").first['count'].to_i
  end

  def self.find(id)
    data = $pg.exec("select * from customer where id = #{id}").first
    Customer.new(name: data['name'], lastname: data['lastname'],
                age: data['age'], code: data['code'], id: data['id'])
  end

  def update(params = {})
    $pg.exec(sql_update_statement(params))
  end

  private

  def sql_update_statement(params)
    %{
      UPDATE customer SET
        name='#{params[:name]}',
        lastname='#{params[:lastname]}',
        code='#{params[:code]}',
        age='#{params[:age]}'
        WHERE id = #{params[:id]}
    }    
  end

  def sql_insert
    "INSERT INTO customer(name, lastname, age, code) VALUES($1,$2,$3,$4)"
  end

  def sql_insert_params
    [name, lastname, age, code]
  end

 

end 