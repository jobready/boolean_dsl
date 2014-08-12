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
      evaluate_boolean(tree[:left], tree[:boolean_operator], tree[:right])
    elsif tree.key?(:expression)
      evaluate(tree[:expression])
    elsif tree.key?(:attribute)
      if context.key?(tree[:attribute].to_s)
        context[tree[:attribute].to_s]
      else
        raise BooleanDsl::EvaluationFailed.new("Context does not have key #{tree[:attribute]}")
      end
    elsif tree.key?(:negation)
      !evaluate(tree[:negation])
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

  # Given a left and right expression and an operator, compares left and right using the operator.
  # Note that unlike evaluate_comparison, left and right are hashes that still need to be evaluated;
  # this is to support short-circuit boolean evaluation
  #
  # @param left [Hash] left operand
  # @param operator [String] the operator
  # @param right [Hash] right operand
  # @return [boolean]
  def evaluate_boolean(left, operator, right)
    case operator
    when 'and'
      evaluate(left) && evaluate(right)
    when 'or'
      evaluate(left) || evaluate(right)
    end
  end
end

