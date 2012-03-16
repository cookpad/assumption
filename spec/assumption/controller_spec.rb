# -*- coding: utf-8 -*-
require 'spec_helper'

describe UsersController, :type => :controller do
  before(:all) do
    UsersController.assume :include => {:user => [:name]}, :only => :new do raise ArgumentError; end
    UsersController.assume :include => :user, :except => [:index] do raise ArgumentError; end
    UsersController.assume :include => :xxx, :only => [:update] do; end
  end

  it 'raise error' do
    expect { get :new }.to raise_exception(ArgumentError)
  end

  it 'no raise error' do
    expect { get :new, :user => {:name => 'alice'} }.to_not raise_exception
  end
  
  it "assumption dosn't work for excepted action" do
    expect { get :index }.to_not raise_exception
  end

  it 'assumption work for specified action' do
    expect { get :show, {:user => ''} }.to_not raise_exception
  end

  describe 'with accessor' do
    before do
      Assumption::ActionController.interrupt = Proc.new { raise ArgumentError}
    end

    after do
    end

    it 'interrupt action always' do
      expect { get :update, {:user => ''} }.to raise_exception(ArgumentError)
    end
  end

  it 'interrupt action always' do
    expect { get :update, {:user => ''} }.to raise_exception(Assumption::InvalidError)
  end
end
