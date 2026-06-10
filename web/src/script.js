try {
    // les await sont top level dans les modules
    const c = await fetch('.');
    console.log(c);

} catch (err) {
    console.error('Erreur : ' + err);
}