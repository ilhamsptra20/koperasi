<?php

namespace App\Http\Controllers;

use App\Models\Place;
use Illuminate\Http\Request;

class PlaceController extends Controller
{
    public function index()
    {
        $place = Place::get();
        return view('place.', compact('place'));
    }

    public function create()
    {
        return view('place.');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'placeType' => 'required',
            'nama' => 'required',
            'alamat' => 'required',
            'filePhoto' => 'required',
            'fgActive' => 'required',
            'catatan' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
            'modifiedBy' => 'required',
            'modifiedDate' => 'required',
        ]);

        Place::create($data);

        return back();
    }

    public function show(Place $place)
    {
        return view('place.', compact('place'));
    }
    
    public function edit(Place $place)
    {
        return view('place.', compact('place'));
    }

    public function update(Request $request, Place $place)
    {
        $data = $request->validate([
            'placeType' => 'required',
            'nama' => 'required',
            'alamat' => 'required',
            'filePhoto' => 'required',
            'fgActive' => 'required',
            'catatan' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
            'modifiedBy' => 'required',
            'modifiedDate' => 'required',
        ]);

        $place->update($data);

        return back();
    }

    public function delete(Place $place)
    {
        $place->delete();
        return back();
    }
}

