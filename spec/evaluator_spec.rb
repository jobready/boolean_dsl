require 'spec_helper'

describe BooleanDsl::Evaluator do
  context '#evaluate_comparison' do
    let(:evaluator) { described_class.new(nil, nil) }

    specify { expect(evaluator.evaluate_comparison(1, '==', 1)).to be_true }
    specify { expect(evaluator.evaluate_comparison(1, '==', 0)).to be_false }
    specify { expect(evaluator.evaluate_comparison(1, '!=', 1)).to be_false }
    specify { expect(evaluator.evaluate_comparison(1, '!=', 0)).to be_true }

    specify { expect(evaluator.evaluate_comparison('alpha', '==', 'alpha')).to be_true }
    specify { expect(evaluator.evaluate_comparison('beta', '==', 'omega')).to be_false }
    specify { expect(evaluator.evaluate_comparison('alpha', '!=', 'alpha')).to be_false }
    specify { expect(evaluator.evaluate_comparison('beta', '!=', 'omega')).to be_true }

    specify { expect(evaluator.evaluate_comparison(10, '<', 20)).to be_true }
    specify { expect(evaluator.evaluate_comparison(20, '<', 10)).to be_false }
    specify { expect(evaluator.evaluate_comparison(20, '>', 10)).to be_true }
    specify { expect(evaluator.evaluate_comparison(10, '>', 20)).to be_false }
    specify { expect(evaluator.evaluate_comparison(20, '<=', 20)).to be_true }
    specify { expect(evaluator.evaluate_comparison(20, '>=', 20)).to be_true }
  end

  context '#evaluate_boolean' do
    let(:evaluator) { described_class.new(nil, nil) }

    specify { expect(evaluator.evaluate_boolean(true, '&&', true)).to be_true }
    specify { expect(evaluator.evaluate_boolean(true, '&&', false)).to be_false }
    specify { expect(evaluator.evaluate_boolean(false, '&&', true)).to be_false }
    specify { expect(evaluator.evaluate_boolean(false, '&&', false)).to be_false }

    specify { expect(evaluator.evaluate_boolean(true, '||', true)).to be_true }
    specify { expect(evaluator.evaluate_boolean(true, '||', false)).to be_true }
    specify { expect(evaluator.evaluate_boolean(false, '||', true)).to be_true }
    specify { expect(evaluator.evaluate_boolean(false, '||', false)).to be_false }
  end

  def to_context(hash = {})
    context = double
    hash.each_pair { |key, value| context.stub(key) { value } }
    context
  end

  context '#evaluate' do
    let(:evaluator) { described_class.new(nil, nil) }

    specify { expect(evaluator.evaluate(integer: '57')).to eq(57) }
    specify { expect(evaluator.evaluate(string: 'alpha5')).to eq('alpha5') }

    context 'attribute' do
      let(:hash) do
        {
          alpha: 'omega',
          gamma: 7,
          delta: true,
          yotta: false,
          beta: nil
        }
      end

      let(:evaluator) { described_class.new(nil, to_context(hash)) }

      specify { expect(evaluator.evaluate(attribute: 'alpha')).to eq('omega') }
      specify { expect(evaluator.evaluate(attribute: 'gamma')).to eq(7) }
      specify { expect(evaluator.evaluate(attribute: 'delta')).to be_true }
      specify { expect(evaluator.evaluate(attribute: 'yotta')).to be_false }
      specify { expect(evaluator.evaluate(attribute: 'beta')).to be_nil }
    end

    specify do
      expect(evaluator.evaluate(
        left: { integer: '1' },
        comparison_operator: '==',
        right: { integer: '1' },
      )).to be_true
    end
    specify do
      expect(evaluator.evaluate(
        left: { integer: '1' },
        comparison_operator: '<',
        right: { integer: '1' },
      )).to be_false
    end
    specify do
      expect(evaluator.evaluate(
        left: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '1' },
        },
        boolean_operator: '&&',
        right: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '1' },
        }
      )).to be_true
    end
    specify do
      expect(evaluator.evaluate(
        left: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '7' },
        },
        boolean_operator: '&&',
        right: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '1' },
        }
      )).to be_false
    end
    specify do
      expect(evaluator.evaluate(
        left: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '9' },
        },
        boolean_operator: '||',
        right: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '1' },
        }
      )).to be_true
    end
    specify do
      expect(evaluator.evaluate(
        left: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '9' },
        },
        boolean_operator: '||',
        right: {
          left: { integer: '7' },
          comparison_operator: '==',
          right: { integer: '2' },
        }
      )).to be_false
    end

    specify do
      expect(evaluator.evaluate(
        expression: {
          left: { integer: '1' },
          comparison_operator: '==',
          right: { integer: '1' }
        }
      )).to be_true
    end

    specify do
      expect(evaluator.evaluate(
        expression: {
          left: { integer: '1' },
          comparison_operator: '!=',
          right: { integer: '1' }
        }
      )).to be_false
    end
  end

  context ''

  context 'full parse' do
    def outcome_for(expression, context_hash = {})
      described_class.new(expression, to_context(context_hash)).outcome
    end

    specify { expect(outcome_for('1 == 1')).to be_true }
    specify { expect(outcome_for('1 == 0')).to be_false }
    specify { expect(outcome_for("(1 < 4 || 5 < 4) && (1 == 1 && 'alpha' == 'alpha')")).to be_true }
    specify { expect(outcome_for('gamma == 7', { gamma: 7 })).to be_true }
    specify { expect(outcome_for('gamma == 8', { gamma: 7 })).to be_false }
    specify { expect(outcome_for("alpha == 'beta'", { alpha: 'beta' })).to be_true }
    specify { expect(outcome_for("alpha == 'beta'", { alpha: 'delta' })).to be_false }
  end
end

