desc "Create fake data."
task :fake_data => [:'db:reset', :environment] do
  i = Initializer.new
  i.init
  i.fill_data
end

class FakeCategory
  attr_reader :name

  def initialize average_cost, probability, name, *descriptions
    @name = name
    @average_cost = average_cost
    @probability = probability
    @descriptions = descriptions
  end

  def generate_transaction?
    rand <= @probability
  end

  def cost
    v = gaussian_rand
    -@average_cost - @average_cost * gaussian_rand * 0.3
  end

  def description
    @descriptions.sample
  end

  def get_transaction date
    Transaction.new \
      date: date,
      category_name: name,
      description: description,
      value: cost
  end

  private
  def gaussian_rand
     u1 = u2 = w = g1 = g2 = 0
     begin
       u1 = 2 * rand - 1
       u2 = 2 * rand - 1
       w = u1 * u1 + u2 * u2
     end while w >= 1

     w = Math::sqrt( ( -2 * Math::log(w)) / w )
     g2 = u1 * w;
     g1 = u2 * w;
  end
end

class Initializer

  def init
    @categories = []
    @categories \
      << FakeCategory.new(801, 0.03, 'electronics', 'macbook', 'new phone') \
      << FakeCategory.new( 40, 0.80, 'eating out') \
      << FakeCategory.new( 80, 0.20, 'alcohol', 'pub', 'pub', 'restocking') \
      << FakeCategory.new( 80, 0.30, 'groceries') \
      << FakeCategory.new( 30, 0.05, 'software') \
      << FakeCategory.new( 50, 0.10, 'car', 'gas', 'cleaning', 'maintenance') \
      << FakeCategory.new(100, 0.08, 'bills', 'rent', 'electricity', 'water') \
      << FakeCategory.new(100, 0.08, 'health', 'drugs', 'dentist')
  end

  def fill_data
    date = Date.today - 6.months
    end_date = Date.today
    while date < end_date
      @categories.each do |c|
        c.get_transaction(date).save if c.generate_transaction?
      end
      date += 1.day
    end
  end
end
