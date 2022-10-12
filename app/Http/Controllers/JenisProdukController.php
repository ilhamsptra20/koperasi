<?php

namespace App\Http\Controllers;

use App\Models\JenisProduk;
use Illuminate\Http\Request;

class JenisProdukController extends Controller
{
    public function index()
    {
        $jenisProduk = JenisProduk::get();
        return view('jenisproduk.', compact('jenisProduk'));
    }

    public function create()
    {
        return view('jenisproduk.');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'jenisProduk' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        JenisProduk::create($data);

        return back()->with('success', 'data berhasil ditambahkan');
    }

    public function show(JenisProduk $JenisProduk)
    {
        return view('jenisproduk.', compact('jenisProduk'));
    }
    
    public function edit(JenisProduk $JenisProduk)
    {
        return view('jenisproduk.', compact('jenisProduk'));
    }

    public function update(Request $request, JenisProduk $JenisProduk)
    {
        $data = $request->validate([
            'jenisProduk' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        $JenisProduk->update($data);

        return back()->with('success', 'data berhasil diubah');
    }

    public function delete(JenisProduk $JenisProduk)
    {
        $JenisProduk->delete();
        return back()->with('success', 'data berhasil dihapus');
    }
}

