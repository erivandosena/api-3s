@extends('layouts.app')

@section('content')
    <h3 class="pb-4 mb-4 font-italic border-bottom">
        {{__("Add New")}} {{__("Division")}}
    </h3>
    <div class="card">
        <div class="card-body">


            @if ($errors->any())
                <ul class="alert alert-danger">
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            @endif

            {!! Form::open(['url' => '/divisions', 'class' => 'form-horizontal', 'files' => true]) !!}

            @include ('divisions.form', ['formMode' => 'create'])

            {!! Form::close() !!}
            <a href="{{ url('/divisions') }}" title="Back"><button class="btn btn-warning btn-sm"><i class="fa fa-arrow-left" aria-hidden="true"></i> Back</button></a>
            <br />
            <br />
        </div>
    </div>
@endsection
