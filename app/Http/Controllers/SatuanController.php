<?php

namespace App\Http\Controllers;

use App\Models\Satuan;
use Illuminate\Http\Request;

class SatuanController extends Controller
{
    public function index()
    {
        $satuan = Satuan::get();
        return view('satuan', compact('satuan'));
    }

    public function create()
    {
        return view('satuan');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'satuan' => 'required',
            'satuanDesc' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        Satuan::create($data);

        return back();
    }

    public function show(Satuan $satuan)
    {
        return view('satuan', compact('satuan'));
    }
    
    public function edit(Satuan $satuan)
    {
        return view('satuan', compact('satuan'));
    }

    public function update(Request $request, Satuan $satuan)
    {
        $data = $request->validate([
            'satuan' => 'required',
            'satuanDesc' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        $satuan->update($data);

        return back();
    }

    public function delete(Satuan $satuan)
    {
        $satuan->delete();
        return back();
    }
}
