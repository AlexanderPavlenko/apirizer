describe Apirizer::ControllerResource do

  it 'merges custom and auto permission' do
    merger = Apirizer::ControllerResource.method(:merge_permission)
    merger.(
      {:a => []},
      %w(a b),
    ).should == ['b', {'a' => []}]
    merger.(
      [:c, {:a => []}],
      %w(a b),
    ).should == ['c', 'b', {'a' => []}]
    merger.(
      [{:b => {:a => []}}, :d, {:c => []}, :c, {:a => []}],
      %w(a b),
    ).should == ['d', {'b' => {:a => []}, 'c' => [], 'a' => []}]
  end
end
