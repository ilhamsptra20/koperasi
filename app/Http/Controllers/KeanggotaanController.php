<?php

namespace App\Http\Controllers;

use App\Models\Keanggotaan;
use Illuminate\Http\Request;

class KeanggotaanController extends Controller
{
    public function index()
    {
        $keanggotaan = Keanggotaan::get();
        return view('tampilan', compact('keanggotaan'));
    }

    public function create()
    {
        return view('tampilan');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'keanggotaan' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        Keanggotaan::create($data);

        return back()->with('success', 'data berhasil ditambahkan');
    }

    public function show(Keanggotaan $keanggotaan)
    {
        return view('tampilan', compact('keanggotaan'));
    }
    
    public function edit(Keanggotaan $keanggotaan)
    {
        return view('tampilan', compact('keanggotaan'));
    }

    public function update(Request $request, Keanggotaan $keanggotaan)
    {
        $data = $request->validate([
            'keanggotaan' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        $keanggotaan->update($data);

        return back()->with('success', 'data berhasil diubah');
    }

    public function delete(Keanggotaan $keanggotaan)
    {
        $keanggotaan->delete();
        return back()->with('success', 'data berhasil dihapus');
    }
}

