# -*- coding: utf-8 -*-
require 'spec_helper'

describe Assumption do
  describe 'input' do
    context 'single' do
      subject { Assumption.assume(:user, {:include => :user}) }
      it { should be_valid  }
    end

    context 'array' do
      subject { Assumption.assume([:user], {:include => :user}) }
      it { should be_valid  }
    end

    context 'hash' do
      subject { Assumption.assume({:user => ''}, {:include => :user}) }
      it { should be_valid  }
    end
  end

  describe 'included' do
    describe 'valid' do
      context 'single column' do
        subject { Assumption.assume(:user, {:include => :user}) }
        it { should be_valid  }
      end

      context 'multi column' do
        subject { Assumption.assume({:user => '', :recipe => ''}, {:include => [:user, :recipe]}) }
        it { should be_valid  }
      end

      context 'nested columns' do
        subject { Assumption.assume({:user => {:name => 'alice'}}, {:include => {:user => :name}})}
        it { should be_valid  }
      end

      context 'hard nested columns' do
        subject { Assumption.assume({:user => {:name => {:last_name => 'last', :first_name => 'first'}}}, {:include => {:user => {:name => [:last_name, :first_name]}}})}
        it { should be_valid  }
      end
    end

    describe 'invalid' do
      context 'single column' do
        subject { Assumption.assume(:recipe, {:include => :user}) }
        it { should_not be_valid  }
        its(:result) { should == {:lack => :user, :surplus => nil}}
      end

      context 'multi column' do
        subject { Assumption.assume({:recipe => ''}, {:include => [:user, :recipe]}) }
        it { should_not be_valid  }
        its(:result) { should == {:lack => [:user], :surplus => nil}}
      end

      context 'nested columns' do
        subject { Assumption.assume({:user => {:phone_numbeer => ''}}, {:include => {:user => :name}})}
        it { should_not be_valid  }
        its(:result) { should == {:lack => {:user => :name}, :surplus => nil}}
      end

      context 'hard nested columns' do
        subject { Assumption.assume({:user => {:name => {:last_name => 'last'}}}, {:include => {:user => {:name => [:last_name, :first_name]}}})}
        it { should_not be_valid  }
        its(:result) { should == {:lack => {:user => {:name => [:first_name]}}, :surplus => nil}}
      end
    end
  end

  describe 'excluded' do
    describe 'valid' do
      context 'single column' do
        subject { Assumption.assume(:recipe, {:exclude => :user}) }
        it { should be_valid  }
      end

      context 'multi column' do
        subject { Assumption.assume({:user => ''}, {:exclude => [:recipe]}) }
        it { should be_valid  }
      end

      context 'nested columns' do
        subject { Assumption.assume({:user => {:name => 'alice'}}, {:exclude => {:user => :phone_number}})}
        it { should be_valid  }
      end

      context 'hard nested columns' do
        subject { Assumption.assume({:user => {:name => {:last_name => 'last'}}}, {:exclude => {:user => {:name => [:first_name]}}})}
        it { should be_valid  }
      end
    end


    describe 'invalid' do
      context 'single column' do
        subject { Assumption.assume(:user, {:exclude => :user}) }
        it { should_not be_valid  }
        its(:result) { should == {:lack => nil, :surplus => :user}}
      end

      context 'multi column' do
        subject { Assumption.assume({:recipe => ''}, {:exclude => [:user, :recipe]}) }
        it { should_not be_valid  }
        its(:result) { should == {:lack => nil, :surplus => [:recipe]}}
      end

      context 'nested columns' do
        subject { Assumption.assume({:user => {:name => 'alice'}}, {:exclude => {:user => :name}})}
        it { should_not be_valid  }
        its(:result) { should == {:lack => nil, :surplus => {:user => :name}}}
      end

      context 'hard nested columns' do
        subject { Assumption.assume({:user => {:name => {:last_name => 'last'}}}, {:exclude => {:user => {:name => [:last_name, :first_name]}}})}
        it { should_not be_valid  }
        its(:result) { should == {:lack => nil, :surplus => {:user => {:name => [:last_name]}}}}
      end
    end
  end

  context 'mix' do
    subject { Assumption.assume({:user => {:name => ''}, :recipe => {:name => ''}}, {:include => {:user => :phone_number}, :exclude => :recipe}) }
    it { should_not be_valid  }
    its(:result) { should == {:lack => {:user => :phone_number}, :surplus => :recipe} }
  end

  describe 'result' do
    subject { Assumption::Result.new([:user], [:recipe])}
    its(:inspect) { should == {:lack => [:user], :surplus => [:recipe]}.inspect }
  end
end
