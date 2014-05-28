class BooleanDsl::Evaluator
  attr_reader :parser, :expression, :context

  def initialize(expression, context)
    @parser = BooleanDsl::Parser.new
    @expression = expression
    @context = context
  end

  def outcome
    tree = parser.parse(expression)

    evaluate(tree)
  end

  def evaluate(tree)
    if tree.key?(:comparison_operator)
      evaluate_comparison(evaluate(tree[:left]), tree[:comparison_operator], evaluate(tree[:right]))
    elsif tree.key?(:boolean_operator)
      evaluate_boolean(evaluate(tree[:left]), tree[:boolean_operator], evaluate(tree[:right]))
    elsif tree.key?(:expression)
      evaluate(tree[:expression])
    elsif tree.key?(:attribute)
      context.send(tree[:attribute])
    elsif tree.key?(:string)
      tree[:string]
    elsif tree.key?(:integer)
      Integer(tree[:integer], 10)
    end
  end

  # Given a left and right value and an operator, compares left to right using the operator.
  #
  # @param left [String, Integer] left operand
  # @param operator [String] the operator
  # @param right [String, Integer] right operand
  # @return [boolean]
  def evaluate_comparison(left, operator, right)
    case operator
    when '=='
      left == right
    when '!='
      left != right
    when '<'
      left < right
    when '<='
      left <= right
    when '>'
      left > right
    when '>='
      left >= right
    end
  end

  # Given a left and right boolean and an operator, compares left and right using the operator.
  #
  # @param left [boolean] left operand
  # @param operator [String] the operator
  # @param right [boolean] right operand
  # @return [boolean]
  def evaluate_boolean(left, operator, right)
    case operator
    when '&&'
      left && right
    when '||'
      left || right
    end
  end
end

